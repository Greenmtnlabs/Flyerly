// Our logger for logging to file and console
var logger = require(__dirname + '/../logger');

var nodemailer = require("nodemailer");

// Get the configurations
var config = require(__dirname + '/../config');


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

CommonFunctions.sendEmail2 = function( eventObj, mailOptions ){
	
	console.log("G bhai iam in CommonFunctions.sendEmail2");
	
	var smtpOptions = {
		host: eventObj.omsHostName, // hostname
	    secureConnection: (eventObj.ssl == "YES"), // use SSL
	    port: eventObj.omsPort, // port for secure SMTP
	    auth: {
	        user: eventObj.email,
	        pass: eventObj.password
	    }
	};
	
	if( eventObj.acType == config.acType.GOOGLE ){
		smtpOptions	=	{
		    service: "Gmail",
		    auth: smtpOptions.auth
		};
	}
	
	
	// create reusable transport method (opens pool of SMTP connections)
	var smtpTransport = nodemailer.createTransport("SMTP", smtpOptions );

	try{
		// send mail with defined transport object
		smtpTransport.sendMail(mailOptions, function(error, response){
		    if(error){
		        console.log("line: "+__line+" ,Error occured while send email");
				logger.info(error);			
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

/*
	Set events object a/c to the Event model
*/
CommonFunctions.getValidEventObj = function( eventObj ) {
	
	
	eventObj.email			=	(eventObj.email != undefined ) ? eventObj.email.trim() : "";
	eventObj.password		=	(eventObj.password != undefined ) ? eventObj.password.trim() : "";
	eventObj.respondingEmail=	(eventObj.respondingEmail != undefined ) ? eventObj.respondingEmail.trim() : "";				
	eventObj.acType			=	(eventObj.acType != undefined ) ? eventObj.acType.trim() : "";
	//acType: String,  //< ICLOUD / EXCHANGE / GOOGLE / YAHOO / AOL / OUTLOOK / OTHER > 				
	//acType = getEmailAcType( user ); //config.acType.GMAIL;
	eventObj.imsHostName	= (eventObj.imsHostName != undefined ) ? eventObj.imsHostName.trim() : "";
	eventObj.imsPort		= (eventObj.imsPort != undefined ) ? eventObj.imsPort.trim() : "";
	eventObj.ssl			= (eventObj.ssl != undefined ) ? eventObj.ssl.trim() : "";

	eventObj.omsHostName	= (eventObj.omsHostName != undefined ) ? eventObj.omsHostName.trim() : "";
	eventObj.omsPort		= (eventObj.omsPort != undefined ) ? eventObj.omsPort.trim() : "";
	
	return eventObj;		
}

/*
return a/c type
*/
CommonFunctions.getEmailAcType = function( email ) {	
	var acType = "";
	email	=	( typeof email == "string" ) ? email : "";
	
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

module.exports = CommonFunctions;