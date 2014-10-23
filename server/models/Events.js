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
	eventId : String ,
	userId : String ,
	spendingTimeTxt : String ,
	startDate : String ,
	endDate : String ,
	hasEndDate : String ,
	location : String ,	
	forwardingNumber : String ,
	emergencyNumbers : String ,
	hasRecording : String ,
	emergencyContacts: Object	
});
module.exports = db.model( 'Events', eventsSchema );