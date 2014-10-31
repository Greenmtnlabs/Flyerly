/**
 * This module is responsible for removing Events, and setting Twillio numbers to FREE
 *
 * Developer: Muhammad Zeeshan
 */
// Reference to the module to be exported
ResetDb = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
ResetDb.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

    app.get('/reset-db', function(req, res) {
        var Twillio = require(__dirname + '/../models/Twillio');
        var Events = require(__dirname + '/../models/Events');

        // remove all events except admin default event
        Events.find({
                recording: {
                    $ne: "DEFAULT1.wav"
                }
            },
            function(err, events) {
                if (err) {
                    logger.error(JSON.stringify(err));
                    return;
                }

                var fs = require('fs');

                for (var i = 0; i < events.length; i++) {
					// remove recording files
                    fs.unlinkSync(__dirname + '/../../recordings/' + events[i].recording);
					logger.info('File ' + events[i].recording + ' removed successfully.');
                }

				// remove events
                Events.remove({
                        recording: {
                            $ne: "DEFAULT1.wav"
                        }
                    },
                    function(err, count) {
                        if (err) {
                            logger.error(JSON.stringify(err));
                            return;
                        }

                        logger.info('Total ' + count + ' Events removed successfully.');

                        // update twillio objects
                        Twillio.update({
                                status: "IN_USE"
                            }, {
                                status: "FREE"
                            }, {
                                safe: true
                            },
                            function(err, count) {

                                if (err) {
                                    logger.error(JSON.stringify(err));
                                    return;
                                }

                                logger.info('Total ' + count + ' twillio updated successfully.');
                                res.json(200, {
                                    status: "OK"
                                });

                            }); // updated end

                    }); // remove end

            }); // find end


    });
}
