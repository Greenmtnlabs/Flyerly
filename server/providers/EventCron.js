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
    // Check if the event is expire
    function checkEvent() {
            var Events = require(__dirname + '/../models/Events');

            // Get today date
            var today = new Date();

            // Current timestamp
            var currentDate = today.getTime();

            Events.find({}, function(err, expire) {

                if (expire != null) {

                    //array to save the twilio number  
                    var array = [];

                    // Loop through all record
                    for (var i = 0; i < expire.length; i++) {

                        // Check if the expire time is end
                        if (expire[i].endTime >= currentDate) {

                            // push the number in array
                            array.push(expire[i].forwadingNumber);

                            // Remove the Event
                            console.log(expire[i]._id);
                            Events.remove({
                                    "_id": expire[i]._id
                                },
                                function(err, removed) {
                                    console.log(removed);
                                });

                        } else {
                            console.log('Else condition');
                        } // end if-else

                    }
                }

            });

            // Set the number as free when event is deleted
            // Var for Twilio models
            var Twillio = require(__dirname + '/../models/Twillio');

            // Iterate through all the number which is free now 
            // and set those number status FREE
            for (var i = 0; i < array.length; i++) {

                Twillio.update({
                        number: array[i]
                    }, {
                        // Set the status 
                        status: 'FREE',
                        assignedTo: ''
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


        } // end checkevent() function
	

	// Setup the Cron job after 30 min
	var minutes = 30, the_interval = minutes * 60 * 1000;
	setInterval(function() {
 	 console.log("I am doing my 30 minutes check");
 	  // Call method
 	  checkEvent();
	}, the_interval);


   
}
