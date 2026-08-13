const { format, addDays, getDay } = require('date-fns');

function getNextWorkingDays(currentDate, numberOfDays) {
    const workingDays = [];
    let dayCount = 0;

    while (workingDays.length <= numberOfDays) {
        const nextDay = addDays(new Date(currentDate), dayCount);

        // Check if the day is a working day (Monday to Friday)
        const dayOfWeek = getDay(nextDay);
        if (dayOfWeek !== 0 && dayOfWeek !== 6) {
            workingDays.push(format(nextDay, 'yyyy-MM-dd'));
        }

        dayCount++;
    }
    workingDays.shift();
    return workingDays; 
}

module.exports = { getNextWorkingDays }