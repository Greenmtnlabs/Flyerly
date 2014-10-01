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

		var op = {'req' : "g bhai"}		
		
		var MailListener = require("mail-listener2");

		var mailListener = new MailListener({
		  username: "rufitestuser1@gmail.com",
		  password: "poster123",
		  host: "imap-host",
		  port: 993, // imap port
		  tls: true,
		  tlsOptions: { rejectUnauthorized: false },
		  mailbox: "INBOX", // mailbox to monitor
		  searchFilter: ["UNSEEN", "FLAGGED"], // the search filter being used after an IDLE notification has been retrieved
		  markSeen: true, // all fetched email willbe marked as seen and not fetched next time
		  fetchUnreadOnStart: true, // use it only if you want to get all unread email on lib start. Default is `false`,
		  mailParserOptions: {streamAttachments: true}, // options to be passed to mailParser lib.
		  attachments: true, // download attachments as they are encountered to the project directory
		  attachmentOptions: { directory: "attachments/" } // specify a download directory for attachments
		});

		mailListener.start(); // start listening

		// stop listening
		//mailListener.stop();

		mailListener.on("server:connected", function(){
		  console.log("imapConnected");
		});

		mailListener.on("server:disconnected", function(){
		  console.log("imapDisconnected");
		});

		mailListener.on("error", function(err){
		  console.log(err);
		});

		mailListener.on("mail", function(mail, seqno, attributes){
		  // do something with mail object including attachments
		  console.log("emailParsed", mail);
		  // mail processing code goes here
		});

		mailListener.on("attachment", function(attachment){
		  console.log(attachment.path);
		});

		// it's possible to access imap object from node-imap library for performing additional actions. E.x.
		//mailListener.imap.move(:msguids, :mailboxes, function(){})
		
	//	res.jsonp(200, op);
	});

}