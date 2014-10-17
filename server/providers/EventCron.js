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
console.log('EventCron');
    // Check if the event is expire
    function checkEvent() {
            var Events = require(__dirname + '/../models/Events');
console.log('checkEvent');
            // Get today date
            var today = new Date();

            // Current timestamp
            var currentDate = today.getTime();

            Events.find({}, function(err, expire) {

                if (expire != null) {

                    console.log('inside if condition');

                    // Loop through all record
                    for (var i = 0; i < expire.length; i++) {

                        // Check if the expire time is end
                        if (expire[i].endTime >= currentDate) {

                            // Set the number as free when event is deleted
                            // Var for Twilio models
                            var Twillio = require(__dirname + '/../models/Twillio');
			    console.log(expire[i].forwadingNumber);

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
				    console.log(model);

                                    // add message to log
                                    logger.info('Number updated successfully');

                                }); // end update

                            console.log('value of ', expire[i]);
                            // Remove the Event after updating
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

                    } //end of for loop
                }

            });



        } // end checkevent() function
    checkEvent();
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
