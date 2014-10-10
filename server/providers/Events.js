/**
 * This module is responsible for handling Events Operations.
 * For Update the data for certain event which is received after number assigned
 * @mraheelmateen
 */
// Reference to the module to be exported
Events = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
Events.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

    // Get the request
    app.post('/event/save', function(req, res) {

        // Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

        // Construct response JSON
        var responseJSON = {};

        // Var for Events models
        var Events = require(__dirname + '/../models/Events');

        var data = req.body;

        // Get the event id from request
        var eventId = req.body.eventId;

        console.log(eventId);


        if (data) {
            // update for the given event 
            Events.update({
                    _id: eventId
                }, {
                    // Set the values of request to event and update
                    $set: {
                        userId: data.userId,
                        startTime: data.startTime,
                        endTime: data.endTime,
                        forwadingNumber: data.forwadingNumber,
                        emergencyContact: data.emergencyContact,
                        socialStatus: data.socialStatus,
                        fbAuth: data.fbAuth,
                        twitterAuth: data.twitterAuth,
                        linkAuth: data.linkAuth,
                        email: data.email,
                        password: data.password,
                        respondingEmail: data.respondingEmail
                    }
                }, {
                    safe: true,
                    upsert: true
                },
                function(err, model) {

                    if (err) {
                        logger.error(JSON.stringify(err));
                        return;
                    }

                    // add message to log
                    logger.info('Event updated successfully');

                    // response to call
                    res.json(200, {
                        status: "OK",
                        eventId: eventId
                    });
                });

        } //end if 


    }); // end post

}
