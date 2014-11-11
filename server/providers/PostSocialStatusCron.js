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

    //postStatusEvent();
    
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
	
	
	// TESTING CODE  ----------------{-------	
	app.all('/fbshare1', function(req, res) {
		
		var FB = require('fb');
		FB.setAccessToken(req.query.t);

		var body = 'My first post using facebook-node-sdk';
		FB.api('me/feed', 'post', { message: body}, function (res2) {
			
		  if(!res2 || res2.error) {
			  var msg = (!res2) ? 'error occurred' : res2.error;			  
		  }
		  else{
			  var msg = 'Post Id: ' + res2.id;
		  }
		  
		  console.log( msg );	  
		  res.jsonp({"In test url , __line":__line, "msg":msg});

		});
		
		/*
		function postToFacebook(str, facebookToken) {
			
			
			
			 //var resEndMsg = 'message='+encodeURIComponent(str)+'&access_token='+encodeURIComponent(facebookToken);
			 
			 var resEndMsg = 'message='+encodeURIComponent(str)+'&access_token='+encodeURIComponent(facebookToken);
			 
			 var https = require('https');
			  var req = https.request({
			    host: 'graph.facebook.com',
			    path: '/me/feed?'+resEndMsg,
			    method: 'GET'
			  }, function(res) {
			    res.setEncoding('utf8');
			    var i=0;
				res.on("data", function(chunk) {
			      console.log('got chunk in data('+i+'): '+chunk);
			    });
			
			    res.on("end", function() {
			      console.log('response end with status: '+res.status);
			    });
			
			  });

		  	  
			  //req.end( resEndMsg );
			  
			  req.end( );
			  
			  
		};


		var facebookToken = "CAACEdEose0cBAGSN54EJxiQ1Wk91n0a5f7nRDe4OlDzZBt8G6LOnqmOMjxKnZBy18gXLBLxZAmiqR72YEhpyDWMA58pcK7G98D3edlyZC6BBg0IB51HlDM2GkAwKjiC8Hor7qO8ADQqq5F0ChHe7pelOSMaQASlPLmMTv4putDs9aP3RPOHNJ8vfHvSr638S6sjbpRrpKtRkjEl8DZBRM";
		postToFacebook('testStatus1', facebookToken);
		*/
				
	});

    app.all('/twshare1', function(req, res) {
    	
		var twitter = require('ntwitter');


		function postToTwitter(access_token_key, access_token_secret, str, callBack) {

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

		var atKey = "2237419165-WQ1iTAKkVElCskn3yy9BQ5w9QncUhRcgFFFlsOB";
		var atSecret = "zFdFt5RE5xJ4p8oE6PlC0ZP3pDU3nFiYbKWVVP5kAwBQh";
		var twittText =	'Untechable Test-'+(new Date());

		postToTwitter(atKey, atSecret, twittText, function( retStatusStr ) {
		  console.log( retStatusStr );
		});
    });
	// TESTING CODE  ----------------}-------    
    
}
