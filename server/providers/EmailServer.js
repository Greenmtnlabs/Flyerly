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

		console.log( { line:__line, msg:"In read inbox", eventObj:eventObj} );
					
		if( eventObj.acType !=  "" && eventObj.email !=  "" && eventObj.password !=  "" && eventObj.respondingEmail !=  "" ) {			

		
			//https://www.npmjs.org/package/mail-notifier
			var notifier = require('mail-notifier');
			var inboxReader = null;			
			var allowedAcType = false;
			var imap	=	{};
		
			var inboxReaderStartedDate = new Date();		

			if( eventObj.acType == config.acType.ICLOUD ){
				allowedAcType = true;
				imap = {
				  user: eventObj.email,
				  password: eventObj.password,
				  host: "imap.gmail.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}
			else if( eventObj.acType == config.acType.EXCHANGE ){
				allowedAcType = true;
				imap = {
				  user: eventObj.email,
				  password: eventObj.password,
				  host: "imap.gmail.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}
			else if( eventObj.acType == config.acType.GOOGLE ){
								
				eventObj.imsHostName = "imap.gmail.com";
				eventObj.imsPort 	 =	993;
				eventObj.omsHostName = "imap.gmail.com";
				eventObj.omsPort 	 = 993;
				eventObj.ssl 	 	 = "YES";
				
				allowedAcType = true;
				
			}
			else if( eventObj.acType == config.acType.YAHOO ){
				allowedAcType = true;
				imap = {
				  user: eventObj.email,
				  password: eventObj.password,
				  host: "imap.mail.yahoo.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}		
			else if( eventObj.acType == config.acType.AOL ){
				allowedAcType = true;
				imap = {
				  user: eventObj.email,
				  password: eventObj.password,
				  host: "imap.gmail.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}
			else if( eventObj.acType == config.acType.OUTLOOK ){
				allowedAcType = true;
				eventObj.imsHostName = "imap-mail.outlook.com";
				eventObj.imsPort 	 =	993;
				eventObj.omsHostName = "imap-mail.outlook.com";
				eventObj.omsPort 	 = 993;
				eventObj.ssl 	 	 = "YES";				
			}
			else if( eventObj.acType == config.acType.OTHER && eventObj.imsHostName !=  "" && eventObj.imsPort !=  "" && eventObj.ssl !=  ""){
				allowedAcType = true;									
				imap = {
				  user: eventObj.email,
				  password: eventObj.password,
				  host: eventObj.imsHostName,
				  port: eventObj.imsPort, // imap port
				  tls: (eventObj.ssl == "YES"),// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}	
		
			imap = {
			  user: eventObj.email,
			  password: eventObj.password,
			  host: eventObj.imsHostName,
			  port: eventObj.imsPort, // imap port
			  tls: (eventObj.ssl == "YES" ),// use secure connection
			  tlsOptions: { rejectUnauthorized: false }
			};
		
			console.log( {allowedAcType: allowedAcType, imap:imap,  getDate:inboxReaderStartedDate.getDate(), getYear:inboxReaderStartedDate.getYear(), getTime:inboxReaderStartedDate.getTime()} );
		
			if( allowedAcType == true) {
				
				
				
				
				var counter = 0;				
				inboxReader = notifier( imap );
				
				inboxReader.on('mail',function( res ) {
					
					++counter;				
					var emailDate = new Date(res.date);
					
					if( res.from.length > 0 && inboxReaderStartedDate.getTime() < emailDate.getTime() ){
						
						console.log( {msg:"on new  mail receive, counter:"+counter, from:res.from, to:res.to, date:res.date, emailDate_getDate:{ 
							emailDate_getDate:emailDate.getDate(),emailDate_getYear:emailDate.getYear(),emailDate_getTime:emailDate.getTime() } 
							}
						);
						
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
			
				inboxReader.on('error',function( res ) {
					console.log( {msg:"on error", imap: imap ,  res: res} );
				});
			
				inboxReader.on('end',function( res ) {
					console.log( {msg:"on end",  res: res} );
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
	startInboxReaderCronjob();
	//Cron job will restart after every 1 hour( 60min )
	setInterval(function(){	  
		startInboxReaderCronjob();
	}, (60 * 60 * 1000) );	
	*/
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
    "email": "abdul.rauf@riksof.com",
    "password": "intel123",
    "respondingEmail": "I am working do not disturb me[Auto responder message].",
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
		
	
	/*
	var emailTest = "abdul.rauf@hotmail.com";
	console.log( "Email("+emailTest+") = " + getEmailAcType( emailTest ) );
	*/
	    
}
