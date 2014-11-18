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
	
	email: String ,
	password: String ,
	respondingEmail: String ,
	
	updatedOn: String
	
});
module.exports = db.model( 'Events', eventsSchema );
