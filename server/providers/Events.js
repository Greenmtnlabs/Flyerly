/**
 * This module is responsible for handling Events Operations.
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

                // Object of the model
                var event = new Events();

                var data = req.body;
                var eventId = req.body.eventId;

                if (data) {
                    // update
                    event.update({
                            _id: eventId
                        }, {
                            $addToSet: {
                                $each : data
                            },
                            {
                                safe: true,
                                upsert: true
                            },
                            function(err, model) {

                                if (err) {
                                    logger.error(JSON.stringify(err));
                                    return;
                                }

                                // add message to log
                                logger.info('Session updated successfully');

                                // response to call
                                res.json(200, {
                                    status: "OK" 
                                });
                            });



                    });
            }

        }
