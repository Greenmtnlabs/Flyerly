//We can track the line number using this code____{_________
Object.defineProperty(global, '__stack', {
  get: function(){
    var orig = Error.prepareStackTrace;
    Error.prepareStackTrace = function(_, stack){ return stack; };
    var err = new Error;
    Error.captureStackTrace(err, arguments.callee);
    var stack = err.stack;
    Error.prepareStackTrace = orig;
    return stack;
  }
});

Object.defineProperty(global, '__line', {
  get: function(){
    return __stack[1].getLineNumber();
  }
});
	//Use bellow code for use	
	//console.log(__stack);
	//console.log(__line);
//We can track the line number using this code____}_________

// Get the configurations
var config = require( __dirname + '/config' );

// Our logger for logging to file and console
var logger = require( __dirname + '/logger' );


// Instance for express server
var express = require( 'express' );
var app = express();

// Initialize Express session
app.use( express.cookieParser() );
app.use( express.favicon() );
app.use(express.session({ secret: config.http.sessionSecret }));
app.use(express.json());
app.use(express.bodyParser());
app.use(express.multipart());

app.use(function noCachePlease(req, res, next) {
    if (req.url === '/') {
      res.header("Cache-Control", "no-cache, no-store, must-revalidate");
      res.header("Pragma", "no-cache");
      res.header("Expires", 0);
    }

    next();
  });




// We want to gzip all our content before sending.
app.use( express.compress() );

var staticContent = require( __dirname + '/providers/StaticContentServer' );
staticContent.setup( app );

var twillio = require( __dirname + '/providers/Twillio' );
twillio.setup( app );

var event = require( __dirname + '/providers/Events' );
event.setup( app );

var eventCron = require( __dirname + '/providers/EventCron' );
eventCron.setup( app );

//var twillioCron = require( __dirname + '/providers/TwillioCron' );
//twillioCron.setup( app );

var twillioServer = require( __dirname + '/providers/TwillioServer' );
twillioServer.setup( app );

var postSocialStatusCron = require( __dirname + '/providers/PostSocialStatusCron' );
postSocialStatusCron.setup( app );

var resetDb = require( __dirname + '/providers/ResetDb' );
resetDb.setup( app );

// Start the http server
var httpServer;
		
// SSL Configurations
if ( config.http.enableSSL ) {
	// We will use https
	var https = require('https');

	// The certificate and ssl key
	var fs = require('fs');
	var privateKey  = fs.readFileSync( config.http.serverKey, 'utf8');
	var certificate = fs.readFileSync( config.http.serverCertificate, 'utf8');

	// Create the server
	httpsServer = https.createServer(credentials, app);
} else {
	var http = require('http');
	httpServer = http.createServer(app);
}


// Make the server listen
httpServer.listen( config.http.port );
logger.info( 'Listening on port ' + config.http.port + ' with SSL ' + config.http.enableSSL );


//Exception handler
process.on('uncaughtException', function (err) {
	var errorMsg  = (new Date).toUTCString() + ' uncaughtException: err.message '+err.message
	    errorMsg +=	', err.stack:'+err.stack;
	logger.info('errorMsg:'+errorMsg);
	logger.info(err);     
});
