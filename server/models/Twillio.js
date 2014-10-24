/**
 * This module is responsible for information related
 * to a Twillio numbers.
 * @mraheelmateen
 */
var db = require( __dirname + '/db' );

/**
 * Scehma of the user object.
 */
var twillioSchema = db.Schema({

	// Twillio Number
	number : String,
	
	sId: String,
	
	// Status of Number
	status : String,
	
	// Validity Period
	validityTime : Number,

	// Asssigned To 
	assignedTo : String
	
	
});
module.exports = db.model( 'Twillio', twillioSchema );
