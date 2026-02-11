const errorHandler = (error, req, res, next) => {
    // Logging the error here
    console.log(error);
    // Returning the status and error message to client
    res.status(400).send({ result: false, error_message: error.message, error:error });
}


module.exports = errorHandler;