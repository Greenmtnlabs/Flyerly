/**
 * This module is responsible for configuring how the server
 * handles errors. There are two kind of errors we will have.
 * One is caused by throwing of exception. The other are not found
 * errors.
 */

// Reference to the module to be exported
errorServer = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 *
 * An error response is sent in the HTTP header. Furthermore,
 * an error JSON is sent.
 */
errorServer.setup = function( app ) {
	
	// Our logger for logging to file and console
	var logger = require( __dirname + '/../logger' );
	
	// Errors caused by exceptions is handled here.
    app.use( function( err, req, res, next ) {
	  	
		// Construct error JSON
		var errorJSON = {
		  error: err,
	  	  request: {
			  params: req.params,
			  query: req.query,
			  body: req.body,
			  files: req.files,
			  route: req.route,
			  cookies: req.cookies,
			  signedCookies: req.signedCookies,
			  originalUrl: req.originalUrl,
			  acceptedLanguages: req.acceptedLanguages,
			  acceptedCharsets: req.acceptedCharsets 
	  	  }, 
	  	  response: {
	  	  	  charset: res.charset,
			  locals: res.locals
	  	  }
	  	}
	  	
		// Log
		logger.error( '500 - Internal Server Error: ' + JSON.stringify( errorJSON ) );
	  	
		// Response to client.
		res.jsonp( 500, errorJSON );
	});
	/*
	// Errors due to a resource not being found are handled
	// here.
	app.get('*', function(req, res){
		
		// Construct error JSON
		var errorJSON = {
	  	  request: {
			  params: req.params,
			  query: req.query,
			  body: req.body,
			  files: req.files,
			  route: req.route,
			  cookies: req.cookies,
			  signedCookies: req.signedCookies,
			  originalUrl: req.originalUrl,
			  acceptedLanguages: req.acceptedLanguages,
			  acceptedCharsets: req.acceptedCharsets 
	  	  }, 
	  	  response: {
	  	  	  charset: res.charset,
			  locals: res.locals
	  	  }
	    }
		
		// Log
		logger.error( '404 - Not Found: ' + JSON.stringify( errorJSON ) );
		
		// Response to client.
	    res.jsonp( 404, errorJSON );
	});*/
}