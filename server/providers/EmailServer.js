/**
 * This module is responsible for handling Email( inbox ) Operations.
 */

// Reference to the module to be exported
EmailServer = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
EmailServer.setup = function( app ) {
	
    // Get the configurations
    var config = require(__dirname + '/../config');
	var CommonFunctions = require( __dirname + '/CommonFunctions' );	
	var nodemailer = require("nodemailer");
	
    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');
	var G_EVENTS = [];
	var G_EMAIL_ADDRESSES = [];
	
	function logMsg( msg ) {
		logger.info( msg );
		//console.log( msg );				
	}
	
	
	/*
	Hook inbox reader event till @stopListiningStrTime	
	@param user == email address
	*/		
	
	function hookInboxReader( eventObj, stopListiningStrTime ) {
		
		eventObj =  CommonFunctions.getValidEventObj( eventObj );

		//console.log( { line:__line, msg:"In read inbox", eventObj:eventObj} );
					
		if( eventObj.acType !=  "" && eventObj.email !=  "" && eventObj.password !=  "" && eventObj.respondingEmail !=  "" ) {			

		
			//https://www.npmjs.org/package/mail-notifier
			var notifier = require('mail-notifier');
			var inboxReader = null;			
			var allowedAcType = false;
			var imap	=	{};
			eventObj.service =	"";	
			
			var inboxReaderStartedDate = new Date();		
			if( eventObj.acType == config.acType.GOOGLE ){
				eventObj.service 	 =	"Gmail";
				
				eventObj.imsHostName = "imap.gmail.com";
				eventObj.imsPort 	 =	993;
				eventObj.iSsl 	 	 = "YES";
								
				eventObj.omsHostName = "smtp.gmail.com";
				eventObj.omsPort 	 = 587;
				eventObj.oSsl 	 	 = "YES";
				
				allowedAcType = true;
			}
			else if( eventObj.acType == config.acType.OUTLOOK ){
				eventObj.service 	 =	"Hotmail";	
							
				eventObj.imsHostName = "imap-mail.outlook.com";
				eventObj.imsPort 	 = 993;
				eventObj.iSsl 	 	 = "YES";				
				
				eventObj.omsHostName = "smtp-mail.outlook.com";
				eventObj.omsPort 	 = 587;
				eventObj.oSsl 	 	 = "YES";				
				
				allowedAcType = true;
			}			
			else if( eventObj.acType == config.acType.YAHOO ){
				eventObj.service 	 =	"Yahoo";		
						
				eventObj.imsHostName = "imap.mail.yahoo.com";
				eventObj.imsPort 	 =	993;
				eventObj.iSsl 	 	 = "YES";
								
				eventObj.omsHostName = "smtp.mail.yahoo.com";
				eventObj.omsPort 	 = 587;
				eventObj.oSsl 	 	 = "YES";
				
				allowedAcType = true;
			}
			else if( eventObj.acType == config.acType.EXCHANGE ){
				eventObj.service 	 =	"Exchange";				
				
				eventObj.imsHostName = "outlook.office365.com";
				eventObj.imsPort 	 =	993;
				eventObj.iSsl 	 	 = "YES";				
				
				eventObj.omsHostName = "smtp.office365.com";
				eventObj.omsPort 	 = 587;
				eventObj.oSsl 	 	 = "YES";
				
				allowedAcType = true;
			}
			else if( eventObj.acType == config.acType.ICLOUD ){
				eventObj.service 	 =	"Icloud";				
				
				eventObj.imsHostName = "imap.mail.me.com";
				eventObj.imsPort 	 =	993;
				eventObj.iSsl 	 	 = "YES";				
				
				eventObj.omsHostName = "smtp.mail.me.com";
				eventObj.omsPort 	 = 587;
				eventObj.oSsl 	 	 = "YES";
				
				allowedAcType = true;
			}				
			else if( eventObj.acType == config.acType.AOL ){
				eventObj.service 	 =	"Aol";				
				
				eventObj.imsHostName = "outlook.office365.com";
				eventObj.imsPort 	 =	993;
				eventObj.iSsl 	 	 = "YES";
				
				eventObj.omsHostName = "smtp.office365.com";
				eventObj.omsPort 	 = 587;
				eventObj.oSsl 	 	 = "YES";
				
				allowedAcType = true;
			}
			else if( eventObj.acType == config.acType.OTHER && eventObj.imsHostName !=  "" && eventObj.imsPort !=  "" && eventObj.iSsl !=  ""){
				allowedAcType = true;									
				imap = {
				  user: eventObj.email,
				  password: eventObj.password,
				  host: eventObj.imsHostName,
				  port: eventObj.imsPort, // imap port
				  tls: (eventObj.iSsl == "YES"),// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}	
		
			imap = {
			  user: eventObj.email,
			  password: eventObj.password,
			  host: eventObj.imsHostName,
			  port: eventObj.imsPort, // imap port
			  tls: (eventObj.iSsl == "YES" ),// use secure connection
			  tlsOptions: { rejectUnauthorized: false }
			};
		
			console.log( {allowedAcType: allowedAcType, imap:imap,  getDate:inboxReaderStartedDate.getDate(), getYear:inboxReaderStartedDate.getYear(), getTime:inboxReaderStartedDate.getTime()} );
		
			if( allowedAcType == true) {
				
				var counter = 0;				
				inboxReader = notifier( imap );
				
				inboxReader.on('mail',function( res ) {
					
					++counter;				
					var emailDate = new Date(res.date);
					
					console.log( { msg:"on mail of EmailServer.js line:"+__line, from:res.from, to:res.to, emailDateA:res.date, resSubject:res.subject, emailDate: emailDate, inboxReaderStartedDate:inboxReaderStartedDate  } );
					
					if( res.from.length > 0 && inboxReaderStartedDate.getTime() < emailDate.getTime() ) {						
						//console.log( {emailRes:res} );						
						console.log( {msg:"on New  mail receive, counter:"+counter, from:res.from, to:res.to, date:res.date, resSubject:res.subject,  emailDate_getDate:{ emailDate_getDate:emailDate.getDate(),emailDate_getYear:emailDate.getYear(),emailDate_getTime:emailDate.getTime() }} );
						
						//I have received the email from this email so we will send him email
						var toEmail = res.from[0].address;
						var toName = res.from[0].name;
						//Email sender were sent email to me, use that to info for sending email as from
						var myEmail = res.to[0].address;
						var myName = res.to[0].name;					
						
						var mailOptions = {
						    from: myName+" < "+myEmail+" >", // sender address
						    to: toEmail, // list of receivers "email1,email2,email3"
						    subject: myName+" is Untechable", // Subject line
						    text: eventObj.respondingEmail, // plaintext body
						    html: eventObj.respondingEmail // html body
						}

						//Check send is not also untechable[ other wise reply will come in a loop ]
						if( myEmail == eventObj.email && G_EMAIL_ADDRESSES.indexOf( toEmail ) < 0 ) {
							console.log("Send him["+toEmail+"], i am untechable");
							CommonFunctions.sendEmail2( eventObj, mailOptions );
						}
					}
				
				});
			
				inboxReader.on('error',function( err ) {
					console.log( {msg:"on error of EmailServer.js line:"+__line, imap: imap ,  err: err} );
				});
			
				inboxReader.on('end',function( res ) {
					console.log( {msg:"on end of EmailServer.js line:"+__line,  res: res} );
				});
			
				inboxReader.start();
			
				setTimeout(function(){
					console.log("Stop listing after time");
					inboxReader.stop();
				}, stopListiningStrTime );
			
			}
		}
		
	}//end fn//
	
	/*	
    1- Listner will listen inbox till 50 minutes(max), then stop listing for 10 minutes, cron will restart after 1 hour(60min)
		if event will expire before 50 mints, then send that minutes of expire.
	*/    
	function startInboxReaderCronjob() {
        logMsg("line:"+__line+", EmailServer.js, startInboxReaderCronjob");
		
	    // Get today's date
	    var today = new Date();
	    // Current timestamp
	    var curTimestamp = today.getTime();	
	
	    var Events = require(__dirname + '/../models/Events');
	    Events.find({			
			email: { $ne : "" },
			password: { $ne : "" },
			respondingEmail: { $ne : "" },					
	        startTime: { $lte: curTimestamp },
            $or: [
		        { endTime: { $gte: curTimestamp } },
				{ hasEndDate: "NO" }
			]
	    }, function(err, events) {
					
			if (err) {
	            logMsg("line:"+__line+", EmailServer.js err: "+err);
	        }
	        else {
	            logMsg( {line:__line, eventsLength:events.length} );
				
				G_EVENTS = [];
				G_EMAIL_ADDRESSES = [];
				
				for (var i = 0; i < events.length; i++) {
					
					events[i].email = events[i].email.trim();
					events[i].password = events[i].password.trim();
					events[i].respondingEmail = events[i].respondingEmail.trim();

					if( events[i].email != "" && events[i].password != "" && events[i].respondingEmail != "" ) {
						//Prevent for multiple entries
						if( G_EMAIL_ADDRESSES.indexOf( events[i].email ) < 0 ) {
							G_EMAIL_ADDRESSES.push( events[i].email );
							G_EVENTS.push( events[i] );
						}
					}
				}
				
				for (var i = 0; i < G_EVENTS.length; i++) {				
					var stopListiningStrTime = (50 * 60 * 1000); //50 minutes
					hookInboxReader( G_EVENTS[i], stopListiningStrTime );
				}
	        }
	    });
		
	}//end fn//
		
	
	startInboxReaderCronjob();
	//Cron job will restart after every 1 hour( 60min )
	setInterval(function(){	  
		startInboxReaderCronjob();
	}, (60 * 60 * 1000) );	
	
	/*
	var stopListiningStrTime = (50 * 60 * 1000); //50 minutes
	var eventObj = {
    "_id": {
        "$oid": "547ee0ba75f5c28033000001"
    },
    "userId": "0",
    "paid": "NO",
    "timezoneOffset": "5.000000",
    "spendingTimeTxt": "DEFAULT1",
    "startTime": "1388538121",
    "endTime":   "1451610121",
    "hasEndDate": "NO",
    "twillioNumber": "+16467590005",
    "location": "",
    "emergencyNumber": "",
    "hasRecording": "YES",
    "recording": "DEFAULT1.wav",
    "socialStatus": "",
    "fbAuth": "",
    "fbAuthExpiryTs": "1412341705",
    "twitterAuth": "",
    "twOAuthTokenSecret": "",
    "linkedinAuth": "",
	
	"acType":"GOOGLE",	
    "email": "abdulrauf618@gmail.com",
    "password": "abcd",
    "respondingEmail": "I am working do not disturb me[Auto responder message2].",
	"serverType":"IMAP",
	"ssl":"YES",
	"imsHostName":"",
	"imsPort":"",
	"omsHostName":"",
	"omsPort":"",
    "updatedOn": "Wed Dec 03 2014 10:06:50 GMT+0000 (UTC)",
    "__v": 0,
    "emergencyContacts": {}
	};
	hookInboxReader( eventObj, stopListiningStrTime );
	*/
	    
}
