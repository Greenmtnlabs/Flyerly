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
    var CommonFunctions = require( __dirname + '/CommonFunctions' );
	var notifier = require('mail-notifier');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');
	var FB = require('fb');
	var twitter = require('ntwitter');
	
	var https = require('https');
	//var request = require('request');
	
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
		//console.log( msg );				
	}
	
    // Check if the event is started, then post socialStatus on social forums
    function postSocialStatus() {
		
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
                logMsg("line:"+__line+", "+ JSON.stringify(err) );
                return;
            }
            if (events != null) {

                logMsg("line:"+__line+", "+ 'Total ' + events.length + ' Events found');

				//Those event id's , which has been started.
				var startedEventIds = [];
				var startedEventIdsCounter = 0;
					
					
                // Loop through all record
                for (var i = 0; i < events.length; i++) {
						
					//logMsg( "line:"+__line+ ", events[i]._id"+events[i]._id+", postSocialStatus= "+ events[i].postSocialStatus );
					
					startedEventIds[ startedEventIdsCounter ] = {_id: events[i]._id};
					startedEventIdsCounter++;
					
					postOnFacebook( events[i], events[i].socialStatus, events[i].fbAuth, events[i].fbAuthExpiryTs );						
					postOnTwitter( events[i], events[i].socialStatus, events[i].twitterAuth, events[i].twOAuthTokenSecret, logMsg);						
					postOnlinkedIn( events[i], events[i].socialStatus, events[i].linkedinAuth );
					
					
					//Send email about event has been started to customized contacts
					postOnEmails( events[i] );

                } //end of for loop

				//mass update all events( becuae we have updated postSocialStatus to true )
				if( startedEventIdsCounter > 0  ) {
					console.log( {line: __line, msg: "Going ot update the status of these ids", startedEventIdsCounter: startedEventIdsCounter, startedEventIds: startedEventIds} );

					//For updating any field, keep in mind, that field must have in Model
					Events
					.update(
						{$or:  startedEventIds },
						{$set: { postSocialStatus:true } },
						{ multi: true },
						function(err, numberAffected, rawResponse) {
							console.log(__line, "Response of update postSocialStatus call", err, numberAffected, rawResponse );
							//logMsg( {line: __line, err:err, numberAffected: numberAffected, rawResponse:rawResponse });
						}
					);
					
					/*
                	Events.findByIdAndUpdate({_id:events[i]._id}, { postSocialStatus:true }, {}, 
						function(err, numberAffected ) {
							console.log(  __line, err, numberAffected);
						//logMsg( {line: __line, err:err, numberAffected: numberAffected });
					}) // executes
					*/
				}
				
            } else {
                logMsg("line:"+__line+", No Events found for posting social status.");
            }
        });
    } // end postSocialStatus function
	
	//Let all email[ friends ] know , I going to untechable, via sending email from my email/password
	function postOnEmails( eventObj ){
		
		eventObj =  CommonFunctions.getValidEventObj( eventObj );
		
		eventObj.customizedContacts = JSON.parse( eventObj.customizedContacts );
		var customizedContactsLength = 0;

		for (var tempI in eventObj.customizedContacts) {
			customizedContactsLength++;
		}

		//console.log("postOnEmails-eventObj:",eventObj,", customizedContactsLength=",customizedContactsLength);

		if( customizedContactsLength > 0 && eventObj.email != "" && eventObj.password != "" ){
						
			console.log("eventObj.allowedAcType:",eventObj.allowedAcType);
			if( eventObj.allowedAcType == true ){
				
				var myEmail = eventObj.email;
				var myName  = eventObj.email;

				for (var i = 0; i < customizedContactsLength; i++) {
					var emailAddresses	=	eventObj.customizedContacts[i].emailAddresses;
					
					//console.log("emailAddresses:",emailAddresses);

					for(var j=0; j<emailAddresses.length; j++ ){
						//send this user email
						var toEmail = emailAddresses[j];
						var toName = emailAddresses[j];
						
						var mailOptions = {
						    from: myName+" < "+myEmail+" >", // sender address
						    to: toEmail, // list of receivers "email1,email2,email3"
						    subject: eventObj.customizedContacts[i].customTextForContact, // Subject line
						    text: eventObj.customizedContacts[i].customTextForContact, // plaintext body
						    html: eventObj.customizedContacts[i].customTextForContact // html body
						}

						//console.log("Send him["+toEmail+"], i am untechable, mailOptions=",mailOptions);

						CommonFunctions.sendEmail2( eventObj, mailOptions );
					}
				}
			}
		}
	}


    // Post on facebook
    function postOnFacebook( curEvent, socialStatus, fbAuth, fbAuthExpiryTs ) {
		var eIdTxt = " (EventId: " + curEvent._id + ") ";
		
        if ( fbAuth == ""  ||  fbAuthExpiryTs == "" ) {
            logMsg({line:__line,eIdTxt: eIdTxt, msg: "fbAuth and fbAuthExpiryTs shouldnot be empty!", fbAuth:fbAuth, fbAuthExpiryTs:fbAuthExpiryTs} );
        }
		else if( fbAuthExpiryTs > curTimestamp ){
			logMsg("line:"+__line+", "+ eIdTxt+"Fb Token expired:"+events[i].fbAuthExpiryTs + " > " + curTimestamp);
		}
		else{
			FB.setAccessToken( fbAuth );

			var body = socialStatus;//'My first post using facebook-node-sdk';
			FB.api('me/feed', 'post', { message: body}, function (res2) {
			
			  if(!res2 || res2.error) {
				  var msg = (!res2) ? ( {a:"Fb posting error occurred."} ) : ( {a:"Fb posting error occurred: ", b:res2.error} );
				  msg.eidTxt = eIdTxt;
			  }
			  else{
				  var msg = 'Fb Post Id: ' + res2.id;
			  }
			  
			  logMsg( {line:__line, msg: msg} );
			});
		}
    }//fb post function end
    
    // Post on twitter
	function postOnTwitter( curEvent, str, access_token_key, access_token_secret, callBack) {
		var eIdTxt = " (EventId: "+curEvent._id+") ";
        if ( access_token_key == "" || access_token_secret == "" ) {                            
			logMsg({line:__line, eIdTxt:eIdTxt, msg: "twitterAuth and twOAuthTokenSecret shouldnot be empty!", twitterAuth:access_token_key, twOAuthTokenSecret:access_token_secret} );
        }
		else {
			var twit = new twitter({
			  consumer_key: config.twitter.consumer_key,
			  consumer_secret: config.twitter.consumer_secret,

			  access_token_key: access_token_key,
			  access_token_secret: access_token_secret
			});

		  	twit.verifyCredentials(function (err, data) {

		        if ( err ) {
		          callBack(__line+"=line"+eIdTxt+" ,Twitter Error verifying credentials: " + err);
  
		        } else {
		          twit.updateStatus(str, function (err, data) {
  
		                if (err) {
		                  callBack(__line+"=line"+eIdTxt+" ,Tweeting failed:"+ err);
		                } else {
						  callBack(__line+"=line"+eIdTxt+" ,Twitter Success!");
		                }
		          });
		        }
		
			});
		}	
	}//twitter post fn end
	
    // Post on linkedIn
    function postOnlinkedIn( curEvent, str, linkedinAccessToken ) {
		var eIdTxt = " (EventId: "+curEvent._id+") ";
        if ( linkedinAccessToken == "" ) {
            logMsg({line:__line, eIdTxt: eIdTxt, msg: "linkedinAccessToken shouldnot be empty!", linkedinAccessToken:linkedinAccessToken} ); 
        }
		else{
			str = str.replace("&","&amp;");
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
		
			var req = https.request( postRequest, function( res ) {
	   
			   logMsg("line:"+__line+", LinkedIn statusCode: "+ res.statusCode );		   
		   
			   buffer = "";
	   
			   res.on( "data", function( data ) { buffer = buffer + data; });
			   res.on( "end",  function( data ) { logMsg("line:"+__line+", "+eIdTxt+ "LinkedIn  buffer: " + buffer ); });
			});

			req.write( body );
			req.end();
		}
    }//linkedin post function end


	//Cron will run after every 5 minute // milli seconds in 5 mint (1000*60*5)
	postSocialStatus();
	setInterval(function(){	  
		postSocialStatus();
	}, (5 * 60 * 1000) );	

	
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