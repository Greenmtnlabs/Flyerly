/**
 * This module is responsible for information related
 * to a user.
 */
var db = require( __dirname + '/db' );

/**
 * Scehma of the user object.
 */
var eventSchema = db.Schema({

	// user ID 	
	userId : String ,
 
	// Start time
	startTime : Number,

	// End time
	endTime : Number,

	// Forwading Number
	forwadingNumber : String,

	// Emergency Number
	emergencyNumber : String,

	// Emergency Contact
	emergencyContact : [],
	
	// Social Status
	socialStatus : String,

	// Fb Auth
	fbAuth : String,

	// Twitter Auth
	twitterAuth : String,

	// LinkdIn Auth
	linkAuth : String,

	// Email 
	email : String,

	// Password
	password : String,

	// Responding Email
	respondingEmail : String
	
	
});
module.exports = db.model( 'Event', eventSchema );
