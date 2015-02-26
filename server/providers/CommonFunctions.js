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
	console.log(data.fromEmail);
	
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
	
	var smtpOptions = {
		host: eventObj.omsHostName, // hostname
	    secureConnection: (eventObj.oSsl == "YES"), // use SSL
	    port: eventObj.omsPort, // port for secure SMTP
	    auth: {
	        user: eventObj.email,
	        pass: eventObj.password
	    }
	};
	
	if( eventObj.acType == config.acType.GOOGLE
		 || eventObj.acType == config.acType.OUTLOOK
		 || eventObj.acType == config.acType.YAHOO
		 || eventObj.acType == config.acType.EXCHANGE
		 || eventObj.acType == config.acType.ICLOUD
		 || eventObj.acType == config.acType.AOL
	){
		
		smtpOptions	=	{
		    service: eventObj.service,
		    auth: smtpOptions.auth
		};
		
	}
	
	
	// create reusable transport method (opens pool of SMTP connections)
	var smtpTransport = nodemailer.createTransport("SMTP", smtpOptions );

	try{

		console.log("smtpOptions:",smtpOptions);
		// send mail with defined transport object
		smtpTransport.sendMail(mailOptions, function(error, response){
		    if(error){
		        console.log("commongFunction.js line: "+__line+" ,Error occured while send email");
				logger.info(error);
				
				CommonFunctions.sendDefaultEmail(mailOptions);

		    }else{
				logger.info("line: "+__line+" ,email sent successfully");
		    }
		    // if you don't want to use this transport object anymore, uncomment following line
		    smtpTransport.close(); // shut down the connection pool, no more messages
		});
	}catch( error ) {
		logger.info("Exception occured while send email");   logger.info(error);
	}
}

CommonFunctions.sendDefaultEmail = function(mailOptions) {
	// send email with default email settings
	var smtpTransport = nodemailer.createTransport("SMTP",{
	    service: "Gmail",
	    auth: {
	        user: config.email.emailAddress,
	        pass: config.email.password
	    }
	});

	smtpTransport.sendMail(mailOptions, function(error, response){
		if(error){
			logger.info("commongFunction.js line: "+__line+" ,Error occured while send email with default settings");
			logger.info(error);
		} else {
			logger.info("line: "+__line+" ,email sent successfully with default settings");
		}
		smtpTransport.close();
	});
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
	eventObj.iSsl			= (eventObj.iSsl != undefined ) ? eventObj.iSsl.trim() : "";

	eventObj.omsHostName	= (eventObj.omsHostName != undefined ) ? eventObj.omsHostName.trim() : "";
	eventObj.omsPort		= (eventObj.omsPort != undefined ) ? eventObj.omsPort.trim() : "";
	eventObj.oSsl			= (eventObj.oSsl != undefined ) ? eventObj.oSsl.trim() : "";	
	
	
	eventObj.allowedAcType = false;
	eventObj.service =	"";	

	if( eventObj.acType == config.acType.GOOGLE ){
		eventObj.service 	 =	"Gmail";
		
		eventObj.imsHostName = "imap.gmail.com";
		eventObj.imsPort 	 =	993;
		eventObj.iSsl 	 	 = "YES";
						
		eventObj.omsHostName = "smtp.gmail.com";
		eventObj.omsPort 	 = 587;
		eventObj.oSsl 	 	 = "YES";
		
		eventObj.allowedAcType = true;
	}
	else if( eventObj.acType == config.acType.OUTLOOK ){
		eventObj.service 	 =	"Hotmail";	
					
		eventObj.imsHostName = "imap-mail.outlook.com";
		eventObj.imsPort 	 = 993;
		eventObj.iSsl 	 	 = "YES";				
		
		eventObj.omsHostName = "smtp-mail.outlook.com";
		eventObj.omsPort 	 = 587;
		eventObj.oSsl 	 	 = "YES";				
		
		eventObj.allowedAcType = true;
	}			
	else if( eventObj.acType == config.acType.YAHOO ){
		eventObj.service 	 =	"Yahoo";		
				
		eventObj.imsHostName = "imap.mail.yahoo.com";
		eventObj.imsPort 	 =	993;
		eventObj.iSsl 	 	 = "YES";
						
		eventObj.omsHostName = "smtp.mail.yahoo.com";
		eventObj.omsPort 	 = 587;
		eventObj.oSsl 	 	 = "YES";
		
		eventObj.allowedAcType = true;
	}
	else if( eventObj.acType == config.acType.EXCHANGE ){
		eventObj.service 	 =	"Exchange";				
		
		eventObj.imsHostName = "outlook.office365.com";
		eventObj.imsPort 	 =	993;
		eventObj.iSsl 	 	 = "YES";				
		
		eventObj.omsHostName = "smtp.office365.com";
		eventObj.omsPort 	 = 587;
		eventObj.oSsl 	 	 = "YES";
		
		eventObj.allowedAcType = true;
	}
	else if( eventObj.acType == config.acType.ICLOUD ){
		eventObj.service 	 =	"Icloud";				
		
		eventObj.imsHostName = "imap.mail.me.com";
		eventObj.imsPort 	 =	993;
		eventObj.iSsl 	 	 = "YES";				
		
		eventObj.omsHostName = "smtp.mail.me.com";
		eventObj.omsPort 	 = 587;
		eventObj.oSsl 	 	 = "YES";
		
		eventObj.allowedAcType = true;
	}				
	else if( eventObj.acType == config.acType.AOL ){
		eventObj.service 	 =	"Aol";				
		
		eventObj.imsHostName = "outlook.office365.com";
		eventObj.imsPort 	 =	993;
		eventObj.iSsl 	 	 = "YES";
		
		eventObj.omsHostName = "smtp.office365.com";
		eventObj.omsPort 	 = 587;
		eventObj.oSsl 	 	 = "YES";
		
		eventObj.allowedAcType = true;
	}
	else if( eventObj.acType == config.acType.OTHER && eventObj.imsHostName !=  "" && eventObj.imsPort !=  "" && eventObj.iSsl !=  ""){
		eventObj.allowedAcType = true;
	}
	return eventObj;	
}

module.exports = CommonFunctions;
