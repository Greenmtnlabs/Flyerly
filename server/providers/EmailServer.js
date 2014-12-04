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

		var user			=	(eventObj.email != undefined ) ? eventObj.email.trim() : "";
		var password		=	(eventObj.password != undefined ) ? eventObj.password.trim() : "";
		var respondingEmail	=	(eventObj.respondingEmail != undefined ) ? eventObj.respondingEmail.trim() : "";				
		var acType			=	(eventObj.acType != undefined ) ? eventObj.acType.trim() : "";
		//acType: String,  //< ICLOUD / EXCHANGE / GOOGLE / YAHOO / AOL / OUTLOOK / OTHER > 				
		//acType = getEmailAcType( user ); //config.acType.GMAIL;
		
		if( acType !=  "" && user !=  "" && password !=  "" && respondingEmail !=  "" ) {			
			console.log( { msg:"In read inbox", user:user, password:password} );
		
			//https://www.npmjs.org/package/mail-notifier
			var notifier = require('mail-notifier');
			var inboxReader = null;			
			var allowedAcType = false;
			var imap	=	{};
		
			var inboxReaderStartedDate = new Date();
			console.log( {getDate:inboxReaderStartedDate.getDate(), getYear:inboxReaderStartedDate.getYear(), getTime:inboxReaderStartedDate.getTime()} );
		

			if( acType == config.acType.ICLOUD ){
				allowedAcType = true;
				imap = {
				  user: user,
				  password: password,
				  host: "imap.gmail.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}
			else if( acType == config.acType.EXCHANGE ){
				allowedAcType = true;
				imap = {
				  user: user,
				  password: password,
				  host: "imap.gmail.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}
			else if( acType == config.acType.GOOGLE ){
				allowedAcType = true;
				imap = {
				  user: user,
				  password: password,
				  host: "imap.gmail.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}
			else if( acType == config.acType.YAHOO ){
				allowedAcType = true;
				imap = {
				  user: user,
				  password: password,
				  host: "imap.mail.yahoo.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}		
			else if( acType == config.acType.AOL ){
				allowedAcType = true;
				imap = {
				  user: user,
				  password: password,
				  host: "imap.gmail.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}
			else if( acType == config.acType.OUTLOOK ){
				allowedAcType = true;
				imap = {
				  user: user,
				  password: password,
				  host: "imap-mail.outlook.com",
				  port: 993, // imap port
				  tls: true,// use secure connection
				  tlsOptions: { rejectUnauthorized: false }
				};
			}
			else if( acType == config.acType.OTHER ){
				
				var imsHostName	= (eventObj.imsHostName != undefined ) ? eventObj.imsHostName.trim() : "";
				var imsPort		= (eventObj.imsPort != undefined ) ? eventObj.imsPort.trim() : "";
				var ssl			= (eventObj.ssl != undefined ) ? eventObj.ssl.trim() : "";
								
				if( imsHostName !=  "" && imsPort !=  "" && ssl !=  "" ) {
					allowedAcType = true;									
					imap = {
					  user: user,
					  password: password,
					  host: imsHostName,
					  port: imsPort, // imap port
					  tls: ssl,// use secure connection
					  tlsOptions: { rejectUnauthorized: false }
					};
				}
			}	
		
		
		
		
			if( allowedAcType == true) {
				var counter = 0;
				inboxReader = notifier(imap);
				inboxReader.on('mail',function( res ) {
					++counter;
				
					var emailDate = new Date(res.date);
				    console.log( { emailDate_getDate:emailDate.getDate(),emailDate_getYear:emailDate.getYear(),emailDate_getTime:emailDate.getTime() } );
					console.log( {msg:"on new  mail receive, counter:"+counter, from:res.from, to:res.to, date:res.date} );

					if( res.from.length > 0 && inboxReaderStartedDate.getTime() < emailDate.getTime() ){
						var fromEmail = res.from[0].address;
						var fromName = res.from[0].name;
					
						var toEmail = res.to[0].address;
						var toName = res.to[0].name;					

						//Check send is not also untechable[ other wise reply will come in a loop ]
						if( toEmail == user && G_EMAIL_ADDRESSES.indexOf( fromEmail ) < 0 ) {
							console.log("Send him["+fromEmail+"] i am untechable");
							CommonFunctions.sendEmail2( eventObj, {
								fromEmail: fromEmail,
								fromName: fromName,
								respondingEmail: respondingEmail,														
								toEmail: toEmail,
								toName: toName
							});
						}
					}
				
				});
			
				inboxReader.on('error',function( res ) {
					console.log( {msg:"on error",  res: res} );
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
	return a/c type
	*/
	function getEmailAcType( email ) {
		var acType = "";
		
		if( email.indexOf("@gmail.com") > -1 ) {
			acType = config.acType.GMAIL;
		}
		else if( email.indexOf("@hotmail.com") > -1 ) {
			acType = config.acType.HOTMAIL;			
		}
		else if( email.indexOf("@yahoo.com") > -1 ) {
			acType = config.acType.YAHOO;			
		}
		
		return acType;
	}
	
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
	var emailTest = "abdul.rauf@hotmail.com";
	console.log( "Email("+emailTest+") = " + getEmailAcType( emailTest ) );
	*/
	    
}
