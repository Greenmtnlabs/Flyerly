/**
 * This module is responsible for information related
 * to a user.
 */
var db = require( __dirname + '/db' );

/**
 * Scehma of the user object.
 */
var userSchema = db.Schema({

	// Username
	userName : String,

	// Password
	password : String	
	
});
module.exports = db.model( 'User', userSchema );
