const crypto = require('crypto');

class ProgressTracker {
  constructor() {
    this.sessions = new Map();
    // Default TTL for active/idle sessions (5 minutes)
    this.DEFAULT_TTL_MS = 5 * 60 * 1000;
    // Post-completion TTL before purging session state (1 minute)
    this.POST_COMPLETE_TTL_MS = 60 * 1000;
  }

  /**
   * Extract uploadId from request body, query, or header; or generate a unique UUID if not provided.
   */
  getOrGenerateUploadId(req) {
    if (!req) return crypto.randomUUID();
    
    let uploadId = null;
    if (req.body && req.body.uploadId) {
      uploadId = String(req.body.uploadId).trim();
    } else if (req.query && req.query.uploadId) {
      uploadId = String(req.query.uploadId).trim();
    } else if (req.headers && (req.headers['x-upload-id'] || req.headers['upload-id'])) {
      uploadId = String(req.headers['x-upload-id'] || req.headers['upload-id']).trim();
    }

    if (!uploadId) {
      uploadId = crypto.randomUUID();
    }

    return uploadId;
  }

  /**
   * Initialize a progress session for a given uploadId if not already existing.
   */
  initProgress(uploadId, message = 'Upload started') {
    if (!uploadId) return;

    if (!this.sessions.has(uploadId)) {
      this.sessions.set(uploadId, {
        uploadId,
        progress: 10,
        status: 'started',
        message: message,
        payload: null,
        clients: new Set(),
        createdAt: Date.now(),
        cleanupTimer: null,
      });
      this.scheduleCleanup(uploadId, this.DEFAULT_TTL_MS);
    } else {
      const session = this.sessions.get(uploadId);
      session.progress = 10;
      session.status = 'started';
      session.message = message;
    }
  }

  /**
   * Update progress for an upload session and broadcast to all connected SSE clients.
   */
  updateProgress(uploadId, progress, status, message, payload = null) {
    if (!uploadId) return;

    let session = this.sessions.get(uploadId);
    if (!session) {
      this.initProgress(uploadId, message);
      session = this.sessions.get(uploadId);
    }

    session.progress = progress;
    session.status = status;
    session.message = message;
    if (payload !== null) {
      session.payload = payload;
    }

    const eventObj = {
      uploadId,
      progress: session.progress,
      status: session.status,
      message: session.message,
    };
    if (session.payload !== null && session.payload !== undefined) {
      eventObj.data = session.payload;
    }

    const eventString = `data: ${JSON.stringify(eventObj)}\n\n`;

    // Broadcast to connected SSE clients
    for (const clientRes of session.clients) {
      try {
        clientRes.write(eventString);
      } catch (err) {
        console.error(`[SSE ProgressTracker] Error writing to client for uploadId ${uploadId}:`, err.message);
        session.clients.delete(clientRes);
      }
    }

    // Handle session end states
    if (status === 'completed' || status === 'error') {
      for (const clientRes of session.clients) {
        try {
          clientRes.end();
        } catch (err) {
          // Client response stream may already be closed
        }
      }
      session.clients.clear();
      // Keep completed/error state briefly so late pollers/connectors get final message
      this.scheduleCleanup(uploadId, this.POST_COMPLETE_TTL_MS);
    }
  }

  /**
   * Subscribe an Express GET response object to the SSE progress stream for a given uploadId.
   */
  subscribe(uploadId, req, res) {
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache, no-transform');
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('X-Accel-Buffering', 'no');

    if (res.flushHeaders) {
      res.flushHeaders();
    }

    let session = this.sessions.get(uploadId);

    if (!session) {
      // Session does not exist yet; create pending session
      this.initProgress(uploadId, 'Waiting for upload to start...');
      session = this.sessions.get(uploadId);
      session.progress = 0;
      session.status = 'pending';
    }

    // Send current status immediately
    const currentObj = {
      uploadId,
      progress: session.progress,
      status: session.status,
      message: session.message,
    };
    if (session.payload !== null && session.payload !== undefined) {
      currentObj.data = session.payload;
    }

    res.write(`data: ${JSON.stringify(currentObj)}\n\n`);

    if (session.status === 'completed' || session.status === 'error') {
      res.end();
      return;
    }

    session.clients.add(res);

    // Handle client connection disconnect / abort
    req.on('close', () => {
      const activeSession = this.sessions.get(uploadId);
      if (activeSession) {
        activeSession.clients.delete(res);
      }
    });
  }

  /**
   * Schedule automatic memory cleanup for session data.
   */
  scheduleCleanup(uploadId, timeoutMs) {
    const session = this.sessions.get(uploadId);
    if (!session) return;

    if (session.cleanupTimer) {
      clearTimeout(session.cleanupTimer);
    }

    session.cleanupTimer = setTimeout(() => {
      this.removeSession(uploadId);
    }, timeoutMs);
  }

  /**
   * Remove session state and close any open connections.
   */
  removeSession(uploadId) {
    const session = this.sessions.get(uploadId);
    if (session) {
      if (session.cleanupTimer) {
        clearTimeout(session.cleanupTimer);
      }
      for (const clientRes of session.clients) {
        try {
          clientRes.end();
        } catch (err) {
          // Connection already closed
        }
      }
      session.clients.clear();
      this.sessions.delete(uploadId);
    }
  }
}

module.exports = new ProgressTracker();
