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

	
		if( acType == config.acType.GMAIL ){
			allowedAcType = true;
			var imap = {
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
			var imap = {
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
			var imap = {
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
			.on('mail',function(mail){
				console.log(('aray baba mail('+(++counter)+') ai='));			
		
				// mail : mail is complete bundle of email						
				console.log( mail );				
				
				console.log( "mail.from:", mail.from);
				console.log( "mail.to:", mail.to );			
		
			})
			.start();		
		}
	}
	
   	app.get('/read-inbox', function( req, res ) {		
		readInbox( "rufi.untechable@gmail.com", "abc123RUFI" );
	});
	
	
	readInbox( "rufi.untechable@gmail.com", "abc123RUFI" );
}
