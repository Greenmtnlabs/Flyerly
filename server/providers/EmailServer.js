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

	function readInbox( user, password ){

		console.log( {"msg:":"In read inbox", user:user, password:password} );
		
		//https://www.npmjs.org/package/mail-notifier
		var notifier = require('mail-notifier');
	
		var acType = config.acType.GMAIL;
		var allowedAcType = false;
		var imap	=	{};
		
		var d = new Date();
		console.log( { getDate:d.getDate(),getYear:d.getYear(),getTime:d.getTime() } );				
		
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
		
		if( allowedAcType == true){
			var counter = 0;
			notifier(imap)
			.on('mail',function( res ) {
				++counter;				
				
			    console.log( "mail.from:", res.from);
                console.log( "mail.to:", res.to );
			    console.log( "mail.date:", res.date);
				
				d = new Date(res.date);
			    console.log( { getDate:d.getDate(),getYear:d.getYear(),getTime:d.getTime() } );				
				

				
				console.log( {msg:"on mail, counter:"+counter} );		
			})
			.on('error',function( res ) {
				console.log( {msg:"on error",  res: res} );
			})
			.on('end',function( res ) {
				console.log( {msg:"on end",  res: res} );
			})
			.start();
			
			setTimeout(function(){
				console.log("Stop listing after time");
				notifier(imap).stop();
			}, (5 * 1 * 1000) );	
			
		}
	}
	
   	app.get('/read-inbox', function( req, res ) {		
		res.end("Nothing to do :)");
	});
	
	
	readInbox( "rufi.untechable@gmail.com", "abc123RUFI" );
	//readInbox( "abdul.rauf@riksof.com", "intel123" );
}
