const admin = require('../../config/firebase');
const { reqNotificationToken } = require('../../models');

/**
 * Send a push notification to a specific user or list of users
 * @param {number|number[]} userIds - User ID or array of User IDs
 * @param {object} notificationPayload - Notification payload containing title, body, and optional data
 * @param {string} notificationPayload.title - Title of the notification
 * @param {string} notificationPayload.body - Body of the notification
 * @param {object} [notificationPayload.data] - Optional metadata/custom data
 */
exports.sendPushNotification = async (userIds, notificationPayload) => {
    try {
        const ids = Array.isArray(userIds) ? userIds : [userIds];
        
        // Retrieve all tokens for these users
        const tokens = await reqNotificationToken.findAll({
            where: { userId: ids },
            attributes: ['token']
        });
        
        if (!tokens.length) {
            console.log(`No push notification tokens found for users: ${ids}`);
            return null;
        }
        
        const registrationTokens = tokens.map(t => t.token);
        
        // Convert any non-string values in data payload to string (required by FCM V1)
        const serializedData = {};
        if (notificationPayload.data) {
            Object.keys(notificationPayload.data).forEach(key => {
                serializedData[key] = String(notificationPayload.data[key]);
            });
        }
        
        const message = {
            notification: {
                title: notificationPayload.title,
                body: notificationPayload.body
            },
            data: serializedData,
            tokens: registrationTokens
        };
        
        // Send message to all retrieved tokens using Firebase Admin SendMulticast
        const response = await admin.messaging().sendEachForMulticast(message);
        
        console.log(`${response.successCount} push notifications sent successfully.`);
        
        // Handle failed tokens (e.g. invalid or unregistered tokens should be removed from database)
        if (response.failureCount > 0) {
            const failedTokens = [];
            response.responses.forEach((resp, idx) => {
                if (!resp.success) {
                    const errorCode = resp.error?.code;
                    // Check if token is invalid or no longer active
                    if (
                        errorCode === 'messaging/invalid-registration-token' ||
                        errorCode === 'messaging/registration-token-not-registered'
                    ) {
                        failedTokens.push(registrationTokens[idx]);
                    }
                }
            });
            
            if (failedTokens.length > 0) {
                console.log(`Removing ${failedTokens.length} stale/invalid tokens from the database.`);
                await reqNotificationToken.destroy({
                    where: { token: failedTokens }
                });
            }
        }
        
        return response;
    } catch (error) {
        console.error('Error sending push notifications:', error);
        throw error;
    }
};
