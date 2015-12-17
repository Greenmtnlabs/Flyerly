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
	
	// Global twilio object
	var twilio = null;
	
	// Image path
	var imagePath = null;

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
            postSocialStatus: { $ne : true },

            
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
				//console.log( 'Event Fetched from the database',events );
					
                // Loop through all record
                for (var i = 0; i < events.length; i++) {
						
					//logMsg( "line:"+__line+ ", events[i]._id"+events[i]._id+", postSocialStatus= "+ events[i].postSocialStatus );
					
					startedEventIds[ startedEventIdsCounter ] = {_id: events[i]._id};
					startedEventIdsCounter++;
					logger.info("Starting UntechableAPI for the event: " + events[i]._id);
					
					if(events[i].fbAuth && events[i].fbAuthExpiryTs && events[i].fbAuthExpiryTs!="" && events[i].fbAuth!=""){
						logger.info("Posting to Facebook for the event: " + events[i]._id);
						postOnFacebook( events[i], events[i].socialStatus, events[i].fbAuth, events[i].fbAuthExpiryTs );	
					} else{
						logger.info("fbAuth or fbAuthExpiryTs not found.");
					}

					if(events[i].twitterAuth && events[i].twOAuthTokenSecret && events[i].twOAuthTokenSecret!="" && events[i].twitterAuth!=""){
						logger.info("Posting to Twitter for the event: " + events[i]._id);
						postOnTwitter( events[i], events[i].socialStatus, events[i].twitterAuth, events[i].twOAuthTokenSecret, logMsg);
					} else{
						logger.info("TwitterAuth or twOAuthTokenSecret not found.");
					}

					if(events[i].linkedinAuth && events[i].linkedinAuth!=""){
						logger.info("Posting to Linkedin for the event: " + events[i]._id);
						postOnlinkedIn( events[i], events[i].socialStatus, events[i].linkedinAuth );
					} else{
						logger.info("LinkedinAuth not found.");
					}					
					
					if(events[i].customizedContacts && events[i].customizedContacts.length>0){
						logger.info("Customized Contacts found for sending email, sms or call");
						//Send email about event has been started to customized contacts
						postOnEmails( events[i] );
						// send calls and sms/s
						postToContacts( events[i] );
					} else {
						logger.info("Customized Contacts not found for sending email, sms or call");
					}

					

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
	
	//Send calls and sms/s 
    function postToContacts( eventObj ) {
    	
    	eventObj =  CommonFunctions.getValidEventObj( eventObj );
    	var fromNumber = config.twilio.default1TwilioNumber;
		
		twilio = require('twilio')(config.twilio.accountSid, config.twilio.authToken);
		
		var contacts = eventObj.customizedContacts;
		// convert customizedContacts to jsonObject only if it's not an object
		if(eventObj.customizedContacts != null){
		if ( typeof eventObj.customizedContacts != 'object'  ) {
			contacts = JSON.parse(eventObj.customizedContacts);
		}
	    var totalDaysHours = calculateHoursDays(eventObj.startTime, eventObj.endTime);
		//SMS body
		var smsBody = eventObj.userName + " is untech for " + totalDaysHours + " with this reason "; 

		//Call body
		var callBody = "You have a message from someone using untech. " + eventObj.userName + " is untech for " + totalDaysHours + " with this reason ";

		//Untech Text and URL 
		var untechCallText = "Reconnect with life. Download at http://www.unte.ch."; 

		var untechSMSText = "Reconnect with life at http://www.unte.ch today."; 

		for (var i in contacts) {
			var smsText =   smsBody + " " + contacts[i].customTextForContact;
			var callText =  callBody + " " + contacts[i].customTextForContact;
			var phones = contacts[i].phoneNumbers;
				logger.info("SMS TEXT: " + smsText);
				logger.info("Call Text: " + callText);
			for ( var j=0; j<phones.length; j++ ) {
				var type = phones[j][0];
				var toNumber = phones[j][1];
				var smsStatus = phones[j][2];
				var callStatus = phones[j][3];

				var toNumber = toNumber.replace(/[^\+\d]/g,"");
				// send sms only if the given number is mobile and sms status is 1
				if ( smsStatus == '1' && type == "Mobile" ) {
					doSms( smsText + " " + untechSMSText, toNumber, fromNumber );
				}

				// send call if call status is 1
				if ( callStatus == '1' ) {
					doCall( callText + untechCallText, toNumber, fromNumber );
				}

			} // loop phones
			smsText = "";
			callText = "";
		} // loop contacts
	 }

    }

    function calculateHoursDays(start, end){
    	var totalHoursDays;    	
    	var OneHour =  60 * 60;
    	var OneDay  =  60 * 60 * 24;    	
    	var diff = Math.abs(Number(end) - Number(start));
    	var minutes = Math.round( diff / 60 );
    	totalHoursDays = Math.round(diff/OneHour);
    	var hourMinutes = diff/OneHour;

    	if(totalHoursDays>48){
    		totalHoursDays = Math.round(diff/OneDay);
    		totalHoursDays = totalHoursDays + " days"; 
    	}else if(totalHoursDays>24){
    		totalHoursDays = Math.round(diff/OneDay);
    		totalHoursDays = totalHoursDays + " day"; 

    	}else if (diff < OneHour){
    		totalHoursDays = minutes + " minutes";
    	}else if(hourMinutes < 2 ){
    		hourMinutes =  minutes - 60;

    		if(totalHoursDays != 1 ){ totalHoursDays = totalHoursDays -1 ;}
    		
    		if(hourMinutes == 0){
    			totalHoursDays = totalHoursDays + " hour ";
    		}else{
    			totalHoursDays = totalHoursDays + " hour " + hourMinutes + " minutes" ;
    		}
    	}else{
    		hours = Math.floor(diff/OneHour);
    		hourMinutes = minutes - ( hours * 60 );
    		if(hours == diff/OneHour){
    			totalHoursDays = hours + " hours";
    		}else{
    			totalHoursDays = hours + " hours " + hourMinutes + " minutes" ;
    		}
    	}
    	logger.info("Number of days or hours:" + totalHoursDays);
    	return totalHoursDays;
    }

    // send sms on given numbers
    function doSms ( body, to, from ) {
    	logger.info("Inside SMS Function");
    	twilio.messages.create({
    		body: body,
    		to: to,
    		from: from
    	}, function(err, message) {
    		if ( err ) {
    			logMsg("Error Sending Message: " + JSON.stringify(err));
    		}
    		logMsg("Message Stat " + JSON.stringify(message));
    	});
    }

    // send call to given number
    function doCall( message, to, from ) {
    	logger.info("Inside Call Function");
    	var twilioCall = require('twilio');
		var resp = new twilioCall.TwimlResponse();

		resp.say('You have a message from your friend via untechable.com',{
			voice:'woman',
			language:'en-gb'
		}).pause({ length:1 });
		resp.say(message,{
			voice:'woman',
			language:'en-gb'
		});
		var url = encodeURIComponent(resp.toString());

		twilio.calls.create({
			url: "http://twimlets.com/echo?Twiml="+url,
			to: to,
			from: from,
			StatusCallback: "http://app.untechable.com:3010/call-status",
			timeout: 20,
		}, function(err, call) {
			if ( err ) {
    			logMsg("Error Making call: " + JSON.stringify(err));
    		}
    		logMsg("Call Stat " + JSON.stringify(call));
		});
    }

    app.post( '/call-status', function( req, res ) {
    	logMsg("================== call-status ==================");
    	console.log(req.body);

    });

	//Let all email[ friends ] know , I going to untechable, via sending email from my email/password
	function postOnEmails( eventObj ){
		
		logger.info("Inside postOnEmails function");
		eventObj =  CommonFunctions.getValidEventObj( eventObj );
		
		if(eventObj.customizedContacts != null)
		{
		eventObj.customizedContacts = JSON.parse( eventObj.customizedContacts );
		var customizedContactsLength = 0;

		for (var tempI in eventObj.customizedContacts) {
			customizedContactsLength++;
		}

		//console.log("postOnEmails-eventObj:",eventObj,", customizedContactsLength=",customizedContactsLength);

		if( customizedContactsLength > 0 && eventObj.email != "" && eventObj.password != "" ){					
			var totalDaysHours = calculateHoursDays(eventObj.startTime, eventObj.endTime);
			var mySubject = "I am unteching for " + totalDaysHours;
			var myEmail = eventObj.email;
			var myName  = eventObj.userName;
			var reason = eventObj.spendingTimeTxt;
			for (var i = 0; i < customizedContactsLength; i++) {
				var emailAddresses	=	eventObj.customizedContacts[i].emailAddresses;
				var toName = eventObj.customizedContacts[i].contactName;
				//console.log("emailAddresses:",emailAddresses);
				if( eventObj.customizedContacts[i].customTextForContact && eventObj.customizedContacts[i].customTextForContact != "" ){
					reason = eventObj.customizedContacts[i].customTextForContact;
				}
				for(var j=0; j<emailAddresses.length; j++ ){
					//send this user email
					var toEmail = emailAddresses[j];
					var body = "Your contact " + myName + " is unteching for " + totalDaysHours + ", with this reason:\n\n" + reason + "\n\nThank you,\nUntech Team\n\nReconnect with life. Get the untech app to easily manage your offline time: http://unte.ch";

					logger.info("Sending email to: " + toEmail);
					var mailOptions = {
					    from: myName+" < "+myEmail+" >", // sender address
					    to: toEmail, // list of receivers "email1,email2,email3"
					    subject: mySubject, // Subject line
					    text: body // html body
					}
					
					//console.log("Send him["+toEmail+"], i am untechable, mailOptions=",mailOptions);
					if( eventObj.allowedAcType == true ){
						CommonFunctions.sendEmail2( eventObj, mailOptions );
					} else {
						// send email with default details
						CommonFunctions.sendDefaultEmail(mailOptions);
					}
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

			imagePath = config.http.host + "/images/untech-social-share-image.jpg";

			FB.setAccessToken( fbAuth );
			var params = {};
			params['message'] = str;
			params['picture'] = imagePath;
			
			FB.api('me/feed', 'post', params, function(res2) {
			  if (!res2 || res2.error) {
			    // an error occured
				var msg = (!res2) ? ( {a:"Fb posting error occurred."} ) : ( {a:"Fb posting error occurred: ", b:res2.error} );
				msg.eidTxt = eIdTxt;

			  } else {
			    // Done
			    var msg = 'Fb Post Id: ' + res2.id;
			  }
			  logMsg( {line:__line, msg: msg} );
			});


			// Old Code	
			// FB.api('me/feed', 'post', { message: socialStatus}, function (res2) {
			
			//   if(!res2 || res2.error) {
			// 	  var msg = (!res2) ? ( {a:"Fb posting error occurred."} ) : ( {a:"Fb posting error occurred: ", b:res2.error} );
			// 	  msg.eidTxt = eIdTxt;
			//   }
			//   else{
			// 	  var msg = 'Fb Post Id: ' + res2.id;
			//   }
			  
			//   logMsg( {line:__line, msg: msg} );
			// });
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