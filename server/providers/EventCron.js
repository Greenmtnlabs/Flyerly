/**
 * This module is responsible for handling Event Cron
 * Check the Expire time of event and delete the event
 * and release the twilio number
 * @mraheelmateen
 */
// Reference to the module to be exported
EventCron = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
EventCron.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

    var fs = require('fs');

    // Check if the event is expire
    function checkEvent() {
            
			logger.info('================= Event cron start ================');

			var Events = require(__dirname + '/../models/Events');

            // Get today date
            var today = new Date();

            // Current timestamp
            var currentDate = today.getTime();

            Events.find({hasEndDate:'YES'}, function(err, expire) {

                if (expire != null) {

                    logger.info('Total ' + expire.length + ' Events found');

                    // Loop through all record
                    for (var i = 0; i < expire.length; i++) {

                        // Check if the expire time is end
                        if (expire[i].endTime >= currentDate) {

                            // Set the number as free when event is deleted
                            // Var for Twilio models
                            var Twillio = require(__dirname + '/../models/Twillio');

                            Twillio.update({
                                    assignedTo: expire[i]._id
                                }, {
                                    // Set the status 
                                    $set: {
                                        status: 'FREE',
                                        assignedTo: ''
                                    }
                                },
                                function(err, model) {

                                    if (err) {
                                        logger.error(JSON.stringify(err));
                                        return;
                                    }

                                    // add message to log
                                    logger.info('Number updated successfully');

                                }); // end update
							
							// delete recording file
							fs.unlinkSync(__dirname + '/../../recordings/' + expire[i].recording);
							logger.info('File ' + expire[i].recording + ' removed successfully.');

                            // Remove Event
                            Events.remove({
                                    "_id": expire[i]._id
                                },
                                function(err, removed) {
									if (err) {
                                        logger.error(JSON.stringify(err));
                                        return;
                                    }

                                   logger.info('Event removed successfully');
                                });



                        } else {
                            logger.info('This event ' + expire[i]._id + ' is not expired yet');
                        } // end if-else

                    } //end of for loop

                } else {
					logger.info('No Events found');
				}

            });


			
        } // end checkevent() function
    
		//checkEvent();
    /*
    // Setup the Cron job after 30 min
    var minutes = 2;
    the_interval = minutes * 60 * 1000;
    setInterval(function() {
        console.log("I am doing my 2 minutes check");
        // Call method
        checkEvent();
    }, the_interval);

    */
}
