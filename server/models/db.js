/**
 * This module is responsible for configuring how the server
 * communicates with its database.
 */
// Our logger for logging to file and console
var config = require( __dirname + '/../config' );

// Reference to the module to be exported
db = module.exports = require( 'mongoose' );
db.connect( config.db.host );