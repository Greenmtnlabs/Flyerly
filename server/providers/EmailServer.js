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

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

	function logMsg( msg ) {
		logger.info( msg );
		//console.log( msg );				
	}

	function readInbox( user, password, respondingEmail, stopListiningStrTime ) {

		console.log( { msg:"In read inbox", user:user, password:password} );
		
		//https://www.npmjs.org/package/mail-notifier
		var notifier = require('mail-notifier');
		var inboxReader = null;
		var acType = config.acType.GMAIL;
		var allowedAcType = false;
		var imap	=	{};
		
		var d = new Date();
		console.log( {getDate:d.getDate(), getYear:d.getYear(), getTime:d.getTime()} );
		
		if( acType == config.acType.GMAIL ){
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
		else if( acType == config.acType.HOTMAIL ){
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
		
		if( allowedAcType == true) {
			var counter = 0;
			inboxReader = notifier(imap);
			inboxReader.on('mail',function( res ) {
				++counter;				
				
			    console.log( "mail.from:", res.from);
                console.log( "mail.to:", res.to );
			    console.log( "mail.date:", res.date);
				
				d = new Date(res.date);
			    console.log( { getDate:d.getDate(),getYear:d.getYear(),getTime:d.getTime() } );				
				

				
				console.log( {msg:"on mail, counter:"+counter} );		
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
	}//end fn//
	
	/*
	Cron job will run after every 1 hour.
    1- Listner will listen inbox till 50 minutes, then stop listing for 10 minutes.
		if event will expire before 50 mints, then send that minutes of expire.
	
		var stopListiningStrTime = (1 * 60 * 1000);
		readInbox( "rufi.untechable@gmail.com", "abc123RUFI", stopListiningStrTime );
		readInbox( "abdul.rauf@riksof.com", "intel123", stopListiningStrTime );		
	*/
	function cronReadInboxStart() {
        logMsg("line:"+__line+", EmailServer.js, cronReadInboxStart");
		
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
		        {endTime: { $gte: curTimestamp } },
				{ hasEndDate: "NO" }
			]
	    }, function(err, events) {
			
			if (err) {
	            logMsg("line:"+__line+", EmailServer.js err: "+err);
	        }
	        else{
	            logMsg( {line:__line, eventsLength:events.length} );
				console.log("events: ",events);
				
				for (var i = 0; i < events.length; i++) {
					if( events[i].email.trim() != "" && events[i].password.trim() != "" && events[i].respondingEmail.trim() != "" ) {
						var stopListiningStrTime = (50 * 60 * 1000); //50minutes
						readInbox( events[i].email, events[i].password, events[i].respondingEmail, stopListiningStrTime );
					}
				}
	        }
	    });
		
	}//end fn//
	
	cronReadInboxStart();
	    
}
