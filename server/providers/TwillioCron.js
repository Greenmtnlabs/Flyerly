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

	     console.log('numberStatus');
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

                                // Make the request for local server to release the number (testing)
                                var request = require('request');
                                request('http://192.168.0.117:3001/release-number', function(error, response, body) {
                                    if (!error && response.statusCode == 200) {
                                        // response to call
                                        response.json(200, {
                                            number: expire[i].number
                                        });
                                    }
                                });

                                // Now delete the record
				expire[i].remove({
                                    "_id": expire[i]._id
                                },
                                function(err, removed) {
                                    console.log(removed);
                                }); // delete end


                            }

                        }
                    }

                }



            });



        } // end numberStatus() function
 numberStatus();

   /* // Setup the Cron job after 30 min
    var minutes = 30;
    the_interval = minutes * 60 * 1000;
    setInterval(function() {
        console.log("I am doing my 30 minutes check");
        // Call method
        numberStatus();

    }, the_interval);*/
}
