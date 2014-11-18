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
config.app.mode.current = config.app.mode.PRODUCTION;

// HTTP server configuration
config.http = {}
config.http.host	=	'';
config.http.sessionSecret = '1234567890FlyerlyApis';
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
config.parse = {}
config.parse.appId = "rrU7ilSR4TZNQD9xlDtH8wFoQNK4st5AaITq6Fan";
config.parse.restApiKey = "CUXUQEZ7O9Nu4FGFiNxQdvHcxE9VAi2lWNi3Y2V5";
config.parse.jsKey = "Q87FRu5s8QFvCbN1rwFXUj19somLIU0aqh9SavHH";

config.url = {};
config.url.download = "https://itunes.apple.com/us/app/flyerly-create-share-flyers/id344130515";
config.url.close = "flyerlyapp://";


config.db.modelVersion = 1.0;
if( config.app.mode.current == config.app.mode.LOCALHOST  ) {
	config.http.port = 3000;
 	// 1-Database setting
 	config.db.host =  '';	
	config.http.host	=	'http://localhost:'+config.http.port;
	
}
else if( config.app.mode.current == config.app.mode.PRODUCTION  ) {
	config.http.port = 80;
	// 1-Database setting
	config.db.host =  '';	
	config.http.host	=	'http://app.flyerly.com:'+config.http.port;
} 
else if( config.app.mode.current == config.app.mode.DEVELOPMENT  ) {
	config.http.port = 80;
	// 1-Database setting
	config.db.host =  '';	
	config.http.host	=	'http://app.flyerly.com:'+config.http.port;
}

// ACCOUNT TYPES
config.acType = {};
config.acType.GMAIL = 'GMAIL';
config.acType.HOTMAIL = 'HOTMAIL';
config.acType.YAHOO = 'YAHOO';


// Make the configuration parameters available.
module.exports = config;