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
	var G_EVENTS = [];
	var G_EMAILS = [];
	
	function logMsg( msg ) {
		logger.info( msg );
		//console.log( msg );				
	}
	
	
	/*
	Hook inbox reader event till @stopListiningStrTime	
	*/
	
	function hookInboxReader( user, password, respondingEmail, stopListiningStrTime ) {

		console.log( { msg:"In read inbox", user:user, password:password} );
		
		//https://www.npmjs.org/package/mail-notifier
		var notifier = require('mail-notifier');
		var inboxReader = null;
		var acType = config.acType.GMAIL;
		var allowedAcType = false;
		var imap	=	{};
		
		var inboxReaderStartedDate = new Date();
		console.log( {getDate:inboxReaderStartedDate.getDate(), getYear:inboxReaderStartedDate.getYear(), getTime:inboxReaderStartedDate.getTime()} );
		
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
				
				var emailDate = new Date(res.date);
			    console.log( { emailDate_getDate:emailDate.getDate(),emailDate_getYear:emailDate.getYear(),emailDate_getTime:emailDate.getTime() } );
				console.log( {msg:"on new  mail receive, counter:"+counter, from:res.from, to:res.to, date:res.date} );

				if( res.from.length > 0 && inboxReaderStartedDate.getTime() < emailDate.getTime() ){
					var emailRecFrom = res.from[0].address;
					//Check send is not also untechable[ other wise reply will come in a loop ]
					if( G_EMAILS.indexOf( emailRecFrom ) < 0 ) {
						console.log("Send him["+emailRecFrom+"] i am untechable");
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
	}//end fn//
	
	/*
	var stopListiningStrTime = (1 * 60 * 1000);
	hookInboxReader( "rufi.untechable@gmail.com", "abc123RUFI", stopListiningStrTime );
	hookInboxReader( "abdul.rauf@riksof.com", "intel123", stopListiningStrTime );		
	*/
	
	
	
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
	        else{
	            logMsg( {line:__line, eventsLength:events.length} );
				
				G_EVENTS = [];
				G_EMAILS = [];
				
				for (var i = 0; i < events.length; i++) {
					
					events[i].email = events[i].email.trim();
					events[i].password = events[i].password.trim();
					events[i].respondingEmail = events[i].respondingEmail.trim();

					if( events[i].email != "" && events[i].password != "" && events[i].respondingEmail != "" ) {
						//Prevent for multiple entries
						if( G_EMAILS.indexOf( events[i].email ) < 0 ) {
							G_EMAILS.push( events[i].email );
							G_EVENTS.push( events[i] );
						}
					}
				}
				
				for (var i = 0; i < G_EVENTS.length; i++) {				
					var stopListiningStrTime = (50 * 60 * 1000); //50 minutes
					hookInboxReader( G_EVENTS[i].email, G_EVENTS[i].password, G_EVENTS[i].respondingEmail, stopListiningStrTime );
				}
				
				
	        }
	    });
		
	}//end fn//
	
	startInboxReaderCronjob();
	//Cron job will restart after every 1 hour( 60min )
	setInterval(function(){	  
		startInboxReaderCronjob();
	}, (60 * 60 * 1000) );	
	
	
	    
}
