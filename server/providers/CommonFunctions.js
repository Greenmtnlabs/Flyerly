// Our logger for logging to file and console
var logger = require(__dirname + '/../logger');

var CommonFunctions = {};


CommonFunctions.print = function( msg ){
	console.log( msg );
}

/*
params required
------------------
@params config [ node config]
@params nodemailer [ node module ]
data.fromEmail
data.fromName
data.respondingEmail
data.toEmail
data.toName
*/
CommonFunctions.sendEmail = function( config, nodemailer, data ){
	// create reusable transport method (opens pool of SMTP connections)
	var smtpTransport = nodemailer.createTransport("SMTP",{
	    service: "Gmail",
	    auth: {
	        user: config.email.emailAddress,
	        pass: config.email.password
	    }
	});
	
	// setup e-mail data with unicode symbols
	var mailOptions = {
	    from: data.toName+" <"+config.email.emailAddress+">", // sender address
	    to: data.fromEmail, // list of receivers "email1,email2,email3"
	    subject: data.toName+" is Untechable", // Subject line
	    text: data.respondingEmail, // plaintext body
	    html: data.respondingEmail // html body
	}

	try{
		// send mail with defined transport object
		smtpTransport.sendMail(mailOptions, function(error, response){
		    if(error){
		        logger.info("Error occured while send email");   logger.info(error);			
		    }else{
				//email sent successfully			
		    }
		    // if you don't want to use this transport object anymore, uncomment following line
		    smtpTransport.close(); // shut down the connection pool, no more messages
		});
	}catch( error ) {
		logger.info("Exception occured while send email");   logger.info(error);
	}
}

CommonFunctions.sendEmail2 = function( event, data ){
	
	console.log("G bhai iam in CommonFunctions.sendEmail2");
	
	var nodemailer = require("nodemailer");
    // Get the configurations
    var config = require(__dirname + '/../config');
	
	
	// create reusable transport method (opens pool of SMTP connections)
	var smtpTransport = nodemailer.createTransport("SMTP",{
		host: "mail.thecreativeblink.com", // hostname
	    secureConnection: false, // use SSL
	    port: 25, // port for secure SMTP
	    auth: {
	        user: "rufi@thecreativeblink.com",
	        pass: "Testing123**"
	    }
	});
	
	// setup e-mail data with unicode symbols
	var mailOptions = {
	    from: "Rufi < rufi@thecreativeblink.com >", // sender address
	    to: "abdul.rauf@riksof.com", // list of receivers "email1,email2,email3"
	    subject: "rufi is Untechable0", // Subject line
	    text: "rufi is untechable1", // plaintext body
	    html: "rufi is untechable2" // html body
	}

	try{
		// send mail with defined transport object
		smtpTransport.sendMail(mailOptions, function(error, response){
		    if(error){
		        console.log("line: "+__line+" ,Error occured while send email");   logger.info(error);			
		    }else{
				console.log("line: "+__line+" ,email sent successfully");
		    }
		    // if you don't want to use this transport object anymore, uncomment following line
		    smtpTransport.close(); // shut down the connection pool, no more messages
		});
	}catch( error ) {
		logger.info("Exception occured while send email");   logger.info(error);
	}
}


module.exports = CommonFunctions;