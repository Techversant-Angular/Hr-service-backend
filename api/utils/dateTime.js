const moment = require('moment');

function getNextWorkingDays(currentDate, numberOfDays) {
    const workingDays = [];
    let dayCount = 0;

    while (workingDays.length <= numberOfDays) {
        const nextDay = moment(currentDate).add(dayCount, 'days');

        // Check if the day is a working day (Monday to Friday)
        if (nextDay.day() !== 0 && nextDay.day() !== 6) {
            workingDays.push(nextDay.format('YYYY-MM-DD'));
        }

        dayCount++;
    }
    workingDays.shift();
    return workingDays; 
}

module.exports = { getNextWorkingDays }