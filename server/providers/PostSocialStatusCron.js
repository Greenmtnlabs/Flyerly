/**
 * This module is responsible for Posting socual status.
 * It fetches current events, and posts social status on Facebook, Twitter
 * and Linkedin.
 * Muhammad Zeeshan
 */
// Reference to the module to be exported
SocialStatusCron = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
SocialStatusCron.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

    // Check if the event is expire
    function postStatusEvent() {

            logger.info('================= PostSocialStatus cron start ================');

            var Events = require(__dirname + '/../models/Events');

            // Get today's date
            var today = new Date();

            // Current timestamp
            var timestamp = today.getTime();

            Events.find({
                startTime: {
                   $lte: timestamp
                },
                postSocialStatus: { $ne : true }
                
            }, function(err, events) {
                console.log(events);
                if (err) {
                    JSON.stringify(err);
                    return;
                }
                if (events != null) {

                    logger.info('Total ' + events.length + ' Events found');

                    // Loop through all record
                    for (var i = 0; i < events.length; i++) {

                        logger.info('Start time : ' + new Date( Number(events[i].startTime) *1000 ));
                        logger.info('End time   : ' + new Date( Number(events[i].endTime) *1000));
                        
                        if ( events[i].postSocialStatus != true ) {
                        
                            // Check if fbAuth is set
                            if (events[i].fbAuth != "") {
                            
                                facebookPost();
                            } else {
                                logger.info('This event does not have fbAuth.');
                            } 
                        }

                    } //end of for loop

                } else {
                    logger.info('No Events found');
                }

            });



        } // end postStatusEvent() function

    postStatusEvent();
    
    // Offline facebook posting
    function facebookPost(){
    
        logger.info('Inside facebook post.');
    }
    
    // Offline facebook posting
    function twitterPost(){ 
        logger.info('Inside twitter post.');
    }
    
    // Offline facebook posting
    function linkedInPost(){
        logger.info('Inside linkedin post.');
    }
}
