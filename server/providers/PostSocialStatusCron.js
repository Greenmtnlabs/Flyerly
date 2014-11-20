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
	
	var https = require('https');
	var request = require('request');
	
    // Get today's date
    var today = new Date();
    // Current timestamp
    var curTimestamp = today.getTime();	
	
    function setTimeInGlobalVars() {
	    today = new Date();

	    // Current timestamp
	    curTimestamp = today.getTime();	
	}
	
	function logMsg( msg ) {
		logger.info( msg );
		console.log( msg );				
	}
	
    // Check if the event is expire
    function postStatusEvent() {		
		
	    setTimeInGlobalVars();
		

        logMsg('================= PostSocialStatus cron start ================');

        var Events = require(__dirname + '/../models/Events');

        Events.find({
            startTime: {
               $lte: curTimestamp
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
                    
                    if ( events[i].postSocialStatus != true && events[i].socialStatus != "") {
						
                            if ( events[i].fbAuth != ""  &&  events[i].fbAuthExpiryTs != "" ) {
                                postOnFacebook( events[i].socialStatus, events[i].fbAuth, events[i].fbAuthExpiryTs );
                            } 
							
                            if ( events[i].twitterAuth != "" && events[i].twOAuthTokenSecret != "" ) {                            
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

    } // end postStatusEvent function
	
	
	
	   
    // Offline facebook posting
    function postOnFacebook( socialStatus, fbAuth, fbAuthExpiryTs ) {
		
		if( fbAuthExpiryTs > curTimestamp ){
			logMsg( "Fb Token expired: "+ events[i].fbAuthExpiryTs + " > " + curTimestamp);
		}
		else{
			FB.setAccessToken(fbAuth);

			var body = socialStatus;//'My first post using facebook-node-sdk';
			FB.api('me/feed', 'post', { message: body}, function (res2) {
			
			  if(!res2 || res2.error) {
				  var msg = (!res2) ? "Fb posting error occurred." : ({a:"Fb posting error occurred: ", b:res2.error});
			  }
			  else{
				  var msg = 'Fb Post Id: ' + res2.id;
			  }		  
			  logMsg( msg );
			});
		}
    }//fb post function end
    
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
	          callBack("Twitter Error verifying credentials: " + err);
  
	        } else {
	          twit.updateStatus(str, function (err, data) {
  
	                if (err) {
	                  callBack('Tweeting failed: ' + err);
	                } else {
	                  callBack('Twitter Success!')
	                }
	          });
	        }
		
		});
	
	}//twitter post fn end
	
	
    function postOnlinkedIn2(str, linkedinAccessToken ){
		logMsg( "In postOnlinkedIn");
		
		var body = '<share>';
			    body += '<comment>'+str+'</comment>';
			    body += '<visibility>';
					body += '<code>anyone</code>';
				body += '</visibility>';
			body += '</share>';				
			
			
		var postRequest = {
			host: 'api.linkedin.com',
			port: 443,
			path: '/v1/people/~/shares?oauth2_access_token=' + linkedinAccessToken,
			method: "POST",
		    headers: {
		        'Cookie': "cookie",
		        'Content-Type': 'text/xml',
		        'Content-Length': Buffer.byteLength(body)
		    }
		};

			
			
		var buffer = "";

		var req = https.request( postRequest, function( res )    {

		   console.log( res.statusCode );
		   var buffer = "";
		   res.on( "data", function( data ) { buffer = buffer + data; } );
		   res.on( "end", function( data ) { console.log( buffer ); } );

		});

		req.write( body );
		req.end();
		
    }//linkedin post function end
	
	

	
	postOnlinkedIn("Test1234", "AQUyRer11RBwK8mE2nqFWl2sYZq5NhgPTn1-J56C-lntwuRHvVBWPZWYrbroRfnUTuyAVPSlqWB2W-NEeYib6W-U8XT70UF2LQ7npgObhha8sylwUH7sfeduWhCMyTM9yR7zc5I-upOfhiwHnN03ECGD3YLSi8wW4qbgneOl3omfz8jhFI8" );
	
	
		
	
	
	
	
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
