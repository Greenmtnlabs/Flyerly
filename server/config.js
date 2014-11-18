/**
 * This module is responsible for maintaining all configurations
 * that are used site wide.
 */
var config = {}	
// Application Information
config.app = {}
config.app.mode = {}
config.app.errorUrl   = '/error';


 
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

config.twitter = {}
config.twitter.consumer_key	=	"GxQAvzs4YXBl2o39TN5nr4ogj";
config.twitter.consumer_secret	=	"IRO1i1pqUdKorBg1fwn4SEzniAeG1GrzpUVXd9mooG4GkpIlNA";


// Db Configuration
config.db = {}
//config.db.host =  'mongodb://admin:untechable@ds043180.mongolab.com:43180/untechable';//M.Zeshan A/c
config.db.modelVersion = 1.0;

config.app.mode.LOCALHOST = 'localhost'; //Port: 3001
config.app.mode.DEVELOPMENT = 'development'; //Port: 8000
config.app.mode.PRODUCTION = 'production';   //Port: 3010

config.app.mode.current = config.app.mode.PRODUCTION;//DEVELOPMENT; //LOCALHOST

// Check if we are on local host
if( config.app.mode.current == config.app.mode.LOCALHOST  ) {
	config.http.port = 3010;
 	// 1-Database setting
	config.db.host =  'mongodb://admin:untechable@ds047930.mongolab.com:47930/untechable';
	config.http.host	=	'http://localhost:'+config.http.port ;
	
}
else if( config.app.mode.current == config.app.mode.DEVELOPMENT  ) {
	config.http.port = 3010;
	// 1-Database setting
	config.db.host =  'mongodb://admin:untechable@ds047930.mongolab.com:47930/untechable';
	config.http.host	=	'http://app.untechable.com:'+config.http.port;
}
else if( config.app.mode.current == config.app.mode.PRODUCTION  ) {
	config.http.port = 3010;
	// 1-Database setting
	config.db.host =  'mongodb://admin:untechable@ds047930.mongolab.com:47930/untechable';
	config.http.host	=	'http://app.untechable.com:'+config.http.port;
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
config.twilio.default1TwilioNumber = "+16467590005";

//Urls of apis
config.urls = {};
config.urls.TWILLIO_CALL_URL = config.http.host + "/ut-handle-call";

//Directory paths
config.dir = {};
config.dir.recordingsPath = __dirname+'/../recordings/';


console.log("config.http.host",config.http.host);


// Make the configuration parameters available.
module.exports = config;
