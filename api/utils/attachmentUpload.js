const uploadAttachment = require('../middleware/uploadAttachment');
const commonController = require('../controller/common.controller');

exports.attachmentRouterInterceptor = async (req, res, next) => {
  if (req.headers['x-api-env'] === 'live') {
    return commonController.generatePresignedUrl(req, res, next);
  } else if (req.headers['x-api-env'] === 'others') {
    uploadAttachment.single("file")(req, res, (err) => {
      if (err) {
        return res.status(400).json({
          result: false,
          message: err.message,
        });
      }

      const protocol = req.headers['x-forwarded-proto'] || req.protocol;
      const host = req.headers['x-forwarded-host'] || req.get('host');
      const relativePath = `qa_uploads_docs/${req.file.filename}`;
      
      return res.status(200).json({
        result: true,
        message: "Attachment uploaded successfully.",
        data: {
          fileName: req.file.filename,
          originalFileName: req.file.originalname,
          filePath: relativePath,
          fileUrl: `${protocol}://${host}/${relativePath}`,
          mimeType: req.file.mimetype,
          fileSize: req.file.size
        }
      });
    });
  }
};