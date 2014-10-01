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

	
   	app.get('/read-inbox', function( req, res ) {
		
		//https://www.npmjs.org/package/mail-notifier
		var notifier = require('mail-notifier');
		
		var imap = {
		  user: "rufitestuser1@gmail.com",
		  password: "poster123",
		  host: "imap.gmail.com",
		  port: 993, // imap port
		  tls: true,// use secure connection
		  tlsOptions: { rejectUnauthorized: false }
		};
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

	});

}