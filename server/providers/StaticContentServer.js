/**
 * This module is responsible for configuring how the server
 * handles requests for static content, images, javascript
 * and html
 */

// Reference to the module to be exported
contentServer = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle JavaScript requests. If the server is being
 * run in development mode, then we expose these directories:
 *
 * - js
 * - libs
 * - tests
 *
 * Otherwise, only the libs directory is exposed. Contents of
 * the js directory are combined to a minimised javascript file.
 */
contentServer.setup = function( app ) {
	// Get the configurations
	var config = require( __dirname + '/../config' );
	
	
	
	// Serve the libs folder
	var express = require('express');
	app.use( '/', express.static( __dirname + '/../../web' ));

	// Serve audio files
	app.use( '/audio', express.static( __dirname + '/../../audio' ));
	
	// Generate error to test correct handling
	app.get( config.app.errorUrl, function(req, res) {
	    throw 'This is a generated error. All requests to this URL will always throw this error';
	});
	
}
