/**
 * This module is responsible for information related
 * to Events .
 * @mraheelmateen
 */
var db = require( __dirname + '/db' );

/**
 * Scehma of the user object.
 */
var eventsSchema = db.Schema({
	// String vars 	
	userId : String ,
	spendingTimeTxt : String ,
	startDate : String ,
	endDate : String ,
	hasEndDate : String ,
	forwardingNumber : String ,
	emergencyNumbers : String ,
	location : String ,
	hasRecording : String ,
	emergencyContacts: Object,
	recording: String	
});
module.exports = db.model( 'Events', eventsSchema );
