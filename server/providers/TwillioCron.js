/**
 * This module is responsible for handling Twilio Cron
 * Check the status of the Number after 29 days
 * and release the twilio number
 * @mraheelmateen
 */
// Reference to the module to be exported
TwillioCron = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
TwillioCron.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

    // Check if the number is Free
    function numberStatus() {
            // Var for Twilio models
            var Twillio = require(__dirname + '/../models/Twillio');

            // Get today date
            var today = new Date();

            // Current timestamp
            var currentDate = today.getTime();

            // Find All
            Twillio.find({}, function(err, expire) {
                if (expire != null) {

                    // Loop through all record
                    for (var i = 0; i < expire.length; i++) {

                        // Check if the expire time is end
                        if (expire[i].status == 'FREE') {

                            // Check the validity time is less than the current time
                            if (expire[i].validityTime <= currentDate) {
				
				// Make the request for local server
                                var request = require('request');
                                request('http://www.google.com', function(error, response, body) {
                                    if (!error && response.statusCode == 200) {

                                        // response to call
                                        res.json(200, {
                                            number: expire[i].number
                                        });
                                    }
                                });

                                Twillio.update({}, {
                                        // Set the status 
                                        status: '',
                                        assignedTo: '',
                                        number: '',
                                        validityTime: ''
                                    },
                                    function(err, model) {

                                        if (err) {
                                            logger.error(JSON.stringify(err));
                                            return;
                                        }

                                        // add message to log
                                        logger.info('Number updated successfully');

                                    }); // end update


                            }

                        }
                    }

                }



            });



        } // end numberStatus() function

    // Setup the Cron job after 30 min
    var minutes = 1,
        the_interval = minutes * 60 * 1000;
    setInterval(function() {
        console.log("I am doing my 30 minutes check");
        // Call method
        numberStatus();

    }, the_interval);
}
