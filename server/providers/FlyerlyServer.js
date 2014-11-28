/**
 * This module is responsible for handling Email( inbox ) Operations.
 */

// Reference to the module to be exported
FlyerlyServer = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
FlyerlyServer.setup = function( app ) {
	
	/*
	Docs url
	https://parse.com/docs/cloud_code_guide
	https://www.parse.com/apps/flyerly--2/cloud_code/script
	http://blog.parse.com/2012/10/11/the-javascript-sdk-in-node-js/
	https://parse.com/questions/users-editing-other-users-in-javascript-sdk
	*/
	
	
    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');	

	function cl( msg ) {
		console.log( msg );
	}
	
	/**
	* When user click on invited link, He will redirect on this url( /download-sc ) with 
	* @parm: i ( inviter id)
	* Here we initialize the session, the auto redirect to download link
	//http://localhost:3000/cs?i=u0DFkKnZNG
	*/
	app.get('/cs', function( req, res ) {
			//req.session.invitee = parseInt(Math.random()*9999999); //current user dummy id
			req.session.inviterObjectId = ""+req.query.i+""; //User id who has invited this current user
			
			res.redirect( config.url.download );
	});
	
	
	app.get('/chks', function( req, res ) {
		res.jsonp({"Chk session , __line":__line, "session":req.session});
	});


	/**
	* When user start the flyerly at very first time, we will auto open safri and redirect to this url( /es )
	* Then we need to check if session has saved any inviter id, then increase the inviteCounter on parse for him
	* and then auto redirect to Close safri url ( flyerlyapp:// )
	* Here iam testing how to increase the inviteCounter on parse for user.		
	*/
	app.get("/es", function( req, res ) {	
		
		function closeBrowser(dataOf, data){
			req.session.inviterObjectId = null;
			//res.jsonp({dataOf : data});
			res.redirect( config.url.close );
		}
		
		if( req.session.inviterObjectId ) {
			 var Parse = require('parse-cloud').Parse;
			 Parse.initialize( config.parse.appId, config.parse.jsKey );
			 
			 Parse.Cloud.run('increaseInviteCounter', {"objectId": req.session.inviterObjectId }, {
			   success: function(result) {
					closeBrowser("result", result);
			   },
			   error: function(error) {
					closeBrowser("error", error);
			   }
			 });			
		}
		else {
			closeBrowser("msg", "inviterObjectId not found in session");
		}
	});
	
	app.get("/test", function( req, res ) {	
		res.jsonp({"In test url of flyerlyApis, FlyerlyServer.js , __line":__line});
	});


}//.setup class end