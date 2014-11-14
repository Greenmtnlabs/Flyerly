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
	var FB = require('fb');
	var twitter = require('ntwitter');
	
	function logMsg( msg ) {
		logger.info( msg );
		console.log( msg );				
	}
	
    // Check if the event is expire
    function postStatusEvent() {

        logMsg('================= PostSocialStatus cron start ================');

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
            
			if (err) {
                logMsg( JSON.stringify(err) );
                return;
            }
            if (events != null) {

                logMsg('Total ' + events.length + ' Events found');

                // Loop through all record
                for (var i = 0; i < events.length; i++) {

                    logMsg('Start time : ' + new Date( Number(events[i].startTime) *1000 ));
                    logMsg('End time   : ' + new Date( Number(events[i].endTime) *1000));
                    
                    if ( events[i].postSocialStatus != true && socialStatus != "") {

                            if (events[i].fbAuth != "" && events[i].fbAuthExpiryTs != "") {                            
                                postOnFacebook( events[i].socialStatus, events[i].fbAuth, events[i].fbAuthExpiryTs );
                            } 
							
                            if (events[i].twitterAuth != "" && events[i].twOAuthTokenSecret != "") {                            
								postOnTwitter(events[i].socialStatus, events[i].twitterAuth, events[i].twOAuthTokenSecret, function( ret ) {
									logMsg( ret );
								});
                            } 
															
                            if ( events[i].linkedinAuth != "" ) {
                                postOnlinkedIn( events[i].socialStatus, events[i].linkedinAuth );
                            } 
                    }
					
					events[i].postSocialStatus = true;
                } //end of for loop
				
				//mass update all events( becuae we have updated postSocialStatus to true )
				
				

            } else {
                logMsg('No Events found');
            }

        });

    } // end postStatusEvent() function
    
    // Offline facebook posting
    function postOnFacebook( socialStatus, fbAuth, fbAuthExpiryTs ) {
        logMsg('Inside facebook post.');
		FB.setAccessToken(fbAuth);

		var body = socialStatus;//'My first post using facebook-node-sdk';
		FB.api('me/feed', 'post', { message: body}, function (res2) {
			
		  if(!res2 || res2.error) {
			  var msg = (!res2) ? 'error occurred' : res2.error;			  
		  }
		  else{
			  var msg = 'Post Id: ' + res2.id;
		  }		  
		  logMsg( msg );
		});		
    }
    
    // Offline twitter posting
	function postOnTwitter(str, access_token_key, access_token_secret, callBack) {

		var twit = new twitter({
		  consumer_key: config.twitter.consumer_key,
		  consumer_secret: config.twitter.consumer_secret,

		  access_token_key: access_token_key,
		  access_token_secret: access_token_secret
		});

	  	twit.verifyCredentials(function (err, data) {

	        if (err) {
	          callBack("Error verifying credentials: " + err);
  
	        } else {
	          twit.updateStatus(str, function (err, data) {
  
	                if (err) {
	                  callBack('Tweeting failed: ' + err);
	                } else {
	                  callBack('Success!')
	                }
	          });
	        }
		
		});
	
	}//end fn
	
	// Offline linkedin posting
    function postOnlinkedIn(str, linkedinAccessToken ){
        logMsg('Inside linkedin post.');
    }
	
	//postStatusEvent();
	
	// TESTING CODE  ----------------{-------	
	/*
	app.all('/fbshare1', function(req, res) {		
		facebookPost();		
	});

    app.all('/twshare1', function(req, res) {
    	twitterPost();
    });	
	
	app.all('/linkedinshare1', function(req, res) {
		//https://api.linkedin.com/v1/people/~/shares		
	});
	*/
	// TESTING CODE  ----------------}-------    
}
