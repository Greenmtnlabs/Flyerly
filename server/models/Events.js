/**
 * This module is responsible for information related
 * to Events .
 * @mraheelmateen , abdul.rauf
 */
var db = require( __dirname + '/db' );

/**
 * Scehma of the user object.
 */
var eventsSchema = db.Schema({

	userId: String ,	
	paid: String ,
	
	timezoneOffset: String ,
	spendingTimeTxt: String ,
    startTime: String ,
    endTime: String ,
	hasEndDate: String ,
    
	twillioNumber: String ,
	location: String ,
    emergencyNumber: String ,
	emergencyContacts: Object ,
	hasRecording: String ,
	recording: String,	
	
	socialStatus: String ,	
	fbAuth: String ,
	fbAuthExpiryTs: String,	
	twitterAuth: String ,
	twOAuthTokenSecret: String,		
	linkedinAuth: String ,
	
	//Field will show on screen2
    acType: String,
    name: String,
    email: String ,
    password: String ,
    respondingEmail: String ,
    //Field will show on screen1
    serverType: String,    
    //INCOMING MAIL SERVER
    imsHostName: String,
    imsUserName: String,    
    imsPassword: String,    
    imsPort: String,
    //OUTGOING MAIL SERVER
    omsHostName: String,
    omsUserName: String,    
    omsPassword: String,
    omsPort: String,
		
	updatedOn: String,
	postSocialStatus: Boolean
	
});
module.exports = db.model( 'Events', eventsSchema );
