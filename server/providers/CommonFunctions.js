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
module.exports = CommonFunctions;