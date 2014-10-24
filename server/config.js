/**
 * This module is responsible for maintaining all configurations
 * that are used site wide.
 */
var config = {}	
// Application Information
config.app = {}
config.app.mode = {}

config.app.errorUrl   = '/error';

config.app.mode.LOCALHOST = 'localhost'; //Port: 3000
config.app.mode.PRODUCTION = 'production';   //Port: 80
config.app.mode.DEVELOPMENT = 'development'; //Port: 3000
config.app.mode.current = config.app.mode.DEVELOPMENT;
 
// HTTP server configuration
config.http = {}
config.http.host	=	'';
config.http.sessionSecret = 'asrhlja sdflkjsdf';
config.http.enableSSL = false;
config.http.serverKey = __dirname + '/../sslcert/server.key';
config.http.serverCertificate = __dirname + '/../sslcert/server.crt';


// Log files
config.logger = {}
config.logger.errorFile = __dirname + '/../logs/error.log';
config.logger.consoleFile = __dirname + '/../logs/console.log';
config.logger.maxFileSize = 1000000;
config.logger.maxFiles = 1;

//Tells can execute cron or not
config.crons = {}
config.crons.cron1 = 1;


// Db Configuration
config.db = {}
//config.db.host =  'mongodb://admin:untechable@ds043180.mongolab.com:43180/untechable';//M.Zeshan A/c
config.db.modelVersion = 1.0;


// Check if we are on local host
if( config.app.mode.current == config.app.mode.LOCALHOST  ) {
	config.http.port = 3000;
 	// 1-Database setting
	config.db.host =  'mongodb://admin:untechable@ds047930.mongolab.com:47930/untechable';
	config.http.host	=	'http://localhost:3001';
	
}
else if( config.app.mode.current == config.app.mode.PRODUCTION  ) {
	config.http.port = 80;
	// 1-Database setting
	config.db.host =  'mongodb://admin:untechable@ds047930.mongolab.com:47930/untechable';
	config.http.host	=	'http://api.typepath.com';
} 
else if( config.app.mode.current == config.app.mode.DEVELOPMENT  ) {
	config.http.port = 3000;
	// 1-Database setting
	config.db.host =  'mongodb://admin:untechable@ds047930.mongolab.com:47930/untechable';
	config.http.host	=	'http://localhost:3000';
}

// ACCOUNT TYPES
config.acType = {};
config.acType.GMAIL = 'GMAIL';
config.acType.HOTMAIL = 'HOTMAIL';
config.acType.YAHOO = 'YAHOO';

// Twilio Account 
config.twilio = {};
config.twilio.accountSid = 'ACe43ba6281588bd243d893ce5326049d7';
config.twilio.authToken = '7c952d7f820c26088e8f7ba2d6f39c2b';
config.twilio.tokenExpiry = 604800;

//Urls of apis
config.urls = {};
config.urls.getForwadingNumUrl = "http://localhost:3001/get-number";

//Directory paths
config.dir = {};
config.dir.recordingsPath = __dirname+'/../recordings/';


// Make the configuration parameters available.
module.exports = config;
