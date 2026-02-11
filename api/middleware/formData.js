const path = require('path')
let moment = require('moment');
const fs = require('fs');

exports.candidateForms = async (req, res, next) => {
    try {


        if (!req.inputFields.candidateResume.candidateResume) {
            return res.status(400).json({ result: false, message: 'Resume is Mandatory' });
        }

        let currentTime = moment().format('YYYY_MM_DD_HH_mm_ss');
        let fileExt = req.inputFields.candidateResume.candidateResume[0].originalFilename.split('.').pop();
        let fileStoragePath = `/uploads/${req.inputFields.candidateFirstName}_${req.inputFields.candidateLastName}_${currentTime}.${fileExt}`;
        let newPath = path.resolve(__dirname, '../..') + fileStoragePath;

        let oldPath = req.inputFields.candidateResume.candidateResume[0].filepath;
        let rawData = fs.readFileSync(oldPath)


        req.inputFields.candidateResume = fileStoragePath;
        fs.writeFile(newPath, rawData, function (err) {
            if (err) throw  err;
            return next();
        })

    } catch (error) {
        next(error);
    }
}


exports.candidateFormsEdit = async (req, res, next) => {
    try {


        if (!req.inputFields.candidateResume.candidateResume) {
            delete req.inputFields.candidateResume;
            return next();
        }

        let currentTime = moment().format('YYYY_MM_DD_HH_mm_ss');
        let fileExt = req.inputFields.candidateResume.candidateResume[0].originalFilename.split('.').pop();
        let fileStoragePath = `/uploads/${req.inputFields.candidateFirstName}_${req.inputFields.candidateLastName}_${currentTime}.${fileExt}`;
        let newPath = path.resolve(__dirname, '../..') + fileStoragePath;

        let oldPath = req.inputFields.candidateResume.candidateResume[0].filepath;
        let rawData = fs.readFileSync(oldPath)


        req.inputFields.candidateResume = fileStoragePath;
        fs.writeFile(newPath, rawData, function (err) {
            if (err) throw err;
            return next();
        })

    } catch (error) {
        next(error);
    }
}
