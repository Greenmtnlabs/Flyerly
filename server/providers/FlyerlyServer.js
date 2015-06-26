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
	
	var testApi = false;
	
    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');	
	
	var Parse = require('parse-cloud').Parse;
	
	Parse.initialize( config.parse.appId, config.parse.jsKey );	

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
		function redirectToDownloadAppUrl( dataOf, data ) {
			var resObj = {dataOf : dataOf, data:data, reqSessionInviterObjectId:req.session.inviterObjectId};
			if( testApi ){
				console.log( resObj ) ;
				res.jsonp( resObj ) ;
			}else{

				var request = require('request');
				request(config.url.download, function (error, response, body) {
				  if ( !error && response.statusCode == 200 ) {
				    res.end( body ) ;
				  } else{
					res.redirect( config.url.download );
				  }				  
				})
			}
		}
		
		if( req.query.i == undefined ){
			redirectToDownloadAppUrl("error", "Inviter Id not found");
		}
		else {
			
			if( req.session.inviterObjectId != undefined ) {	
				//don not do any thing till user has session
								//console.log("not increae , req.session.inviterObjectId :",req.session.inviterObjectId );
								redirectToDownloadAppUrl("error", "Session already created.");
			}
			else {
	 			//req.session.invitee = parseInt(Math.random()*9999999); //current user dummy id
	 			req.session.inviterObjectId = ""+req.query.i+""; //User id who has invited this current user
				
				//console.log("Increaes");
				 //Actual body of this function is in parse cloud, this will increase the inviteSessions on parse
				 Parse.Cloud.run('parseCloudeCodeIncreaseInviteCounter', {"objectId": req.session.inviterObjectId }, {
				   success: function(result) {
						redirectToDownloadAppUrl("result", result);
				   },
				   error: function(error) {
						redirectToDownloadAppUrl("error", error);
				   }
				 });
		    }
			 

			 
		}
			
			
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
		
		function closeBrowser(dataOf, data) {
			req.session.inviterObjectId = null;
			if( testApi ) {
				var resObj = {dataOf : dataOf, data:data, reqSessionInviterObjectId:req.session.inviterObjectId};			
				console.log( resObj ) ;
				res.jsonp( resObj ) ;				
			}else {				
				res.redirect( config.url.close );				
			}

		}
		
		if( req.session.inviterObjectId ) {			 

			 //Actual body of this function is in parse cloud, this will increase the inviteCounter on parse
			 Parse.Cloud.run('parseCloudeCodeIncreaseInviteSessions', {"objectId": req.session.inviterObjectId }, {
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