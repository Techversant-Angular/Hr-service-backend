const admin = require('../../config/firebase');
const { reqNotificationToken } = require('../../models');

// const STALE_TOKEN_ERROR_CODES = new Set([
//     'messaging/invalid-argument',
//     'messaging/invalid-registration-token',
//     'messaging/registration-token-not-registered'
// ]);

// const isValidFcmRegistrationToken = (token) => {
//     if (typeof token !== 'string') return false;

//     const trimmedToken = token.trim();
//     if (!trimmedToken) return false;
//     if (trimmedToken !== token) return false;
//     if (trimmedToken.length < 20 || trimmedToken.length > 4096) return false;
//     if (/\s/.test(trimmedToken)) return false;

//     return /^[A-Za-z0-9_:\-]+$/.test(trimmedToken);
// };

/**
 * Send a push notification to a specific user or list of users
 * @param {number|number[]} userIds - User ID or array of User IDs
 * @param {object} notificationPayload - Notification payload containing title, body, and optional data
 * @param {string} notificationPayload.title - Title of the notification
 * @param {string} notificationPayload.body - Body of the notification
 * @param {object} [notificationPayload.data] - Optional metadata/custom data
 */
exports.sendPushNotification = async (token,title,body) => {
    const message = {
        notification: {
            title: title,
            body: body
        },
        token: token
    };
    try {
        const response = await admin.messaging().send(message);
        
        return response;
    } catch (error) {
        console.error('Error sending push notifications:', error);
        throw error;
    }
};

// exports.isValidFcmRegistrationToken = isValidFcmRegistrationToken;
