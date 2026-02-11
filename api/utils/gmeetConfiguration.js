const { google } = require('googleapis');
const moment = require('moment-timezone');

// OAuth2 client setup
const { OAuth2 } = google.auth;
const oAuth2Client = new OAuth2(
  '160834497079-egc0s44arba2ihilar3fbs7ub0d4sste.apps.googleusercontent.com',
  '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'
);

// Set credentials with a valid refresh token
oAuth2Client.setCredentials({
  refresh_token: '1//04mC66nzICxJfCgYIARAAGAQSNwF-L9IrnZQgap93Texxg3Tq51Kd5H9O6rSpATdY4LFAkK5rKHaAPRhK-ZxfZ3wZu4ixHS_SMY8', // Replace with your Refresh Token
});

// Google Calendar API instance
const calendar = google.calendar({ version: 'v3', auth: oAuth2Client });

async function googleMeetApi(dateTime, attendees = [
  { email: 'attendee1@example.com' },
  { email: 'attendee2@example.com' },
]) {
return "";
//  const eventStartTime = moment.tz(dateTime, "YYYY-MM-DD HH:mm", "Asia/Kolkata");
//  const eventEndTime = moment.tz(dateTime, "YYYY-MM-DD HH:mm", "Asia/Kolkata").add(1, 'hours');

//  const event = {
//    summary: 'Interview Scheduled',
//    location: 'Online',
//    description: 'Interview',
//    start: {
//      dateTime: eventStartTime.format(), // Use `.format()` to get ISO-like string
//      timeZone: "Asia/Kolkata",
//    },
//    end: {
//      dateTime: eventEndTime.format(),
//      timeZone: "Asia/Kolkata",
//    },
//    attendees: attendees, // Dynamically map attendee emails
//    conferenceData: {
//      createRequest: {
//        requestId: 'unique-request-id', // Unique identifier for the request
//        conferenceSolutionKey: { type: 'hangoutsMeet' },
//      },
//    },
//  };

//  try {
    // Check calendar availability
//    const freeBusyResult = await calendar.freebusy.query({
//      resource: {
//        timeMin: eventStartTime.toISOString(),
//        timeMax: eventEndTime.toISOString(),
//        timeZone: 'Asia/Kolkata',
//        items: [{ id: 'primary' }],
//      },
//    });

   // const busySlots = freeBusyResult.data.calendars.primary.busy;
    // if (busySlots.length > 0) {
    //   console.log("You're busy during this time.");
    //   return null;
    // }

    // Create the event
 //   const eventResponse = await calendar.events.insert({
 //     calendarId: 'primary',
 //     resource: event,
  //    conferenceDataVersion: 1, // Required for Meet link generation
   // });

 //   const meetLink = eventResponse.data.conferenceData.entryPoints[0].uri;
 //   console.log('Google Meet Link:', meetLink);

  //  return meetLink;
 // } catch (error) {
  //  console.error('Error:', error.message);
  //  throw error; // Re-throw the error for upstream handling
 // }
}



module.exports = {
  googleMeetApi
}
