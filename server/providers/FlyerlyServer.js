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
	
    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');	


	/**
	* When user click on invited link, He will redirect on this url( /download-sc ) with 
	* @parm: i ( inviter id)
	* Here we initialize the session, the auto redirect to download link
	*/
	app.get('/download-sc', function( req, res ) {
		
			req.session.inviter = ""+req.query.i+"";
			req.session.invitee = parseInt(Math.random()*9999999);
		

			res.end('<html>\
			<head>\
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />\
			<title>Session Created Successfully!</title>\
			</head>\
			<body>\
			<a href="/download-c"> Go to /download-c and check your session </a> <br/> <br/> <br/> \
			<a href="https://itunes.apple.com/us/app/flyerly-create-share-flyers/id344130515" > Download </a> <br/> \
			\
			01- req.session.inviter: '+req.session.inviter+' <br/> req.session.invitee: '+req.session.invitee +'\
			<body>\
		    </htlm>');
		
	});


	/**
	* When user start the flyerly at very first time, we will auto open safri and redirect to this url( /download-c )
	* Then we need to check if session has saved any inviter id, then increase the inviteCounter on parse for him
	* and then auto redirect to Close safri url ( flyerlyapp:// )
	*/
	app.get('/download-c', function( req, res ) {
		res.end('<html>\
		<head>\
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />\
		<title>Session Check</title>\
		</head>\
		<body>\
		<a href="flyerlyapp://">Close</a> <br/> \
		02- req.session.inviter: '+req.session.inviter+' <br/> req.session.invitee: '+req.session.invitee +'\
		<body>\
	    </htlm>');
		
	});



	/**
	* Here iam testing how to increase the inviteCounter on parse for user.
	*/
	app.get('/increase-counter', function( request, response ) {
		
		

		
		//http://blog.parse.com/2012/10/11/the-javascript-sdk-in-node-js/
		
		var Parse = require('parse-cloud').Parse;
		Parse.initialize( config.parse.appId, config.parse.jsKey );
		
		Parse.Cloud.define("modifyUser", function(request, response) {
			console.log('hello4');
		
		  if (!request.user) {
		    response.error("Must be signed in to call this Cloud Function.")
					console.log('hello5');
		    return;
		  }
		  // The user making this request is available in request.user
		  // Make sure to first check if this user is authorized to perform this change.
		  // One way of doing so is to query an Admin role and check if the user belongs to that Role.
		  // Replace !authorized with whatever check you decide to implement.
		  if (!authorized) {
			  		console.log('hello6');
		    response.error("Not an Admin.")
		    return;    
		  }

		  // The rest of the function operates on the assumption that request.user is *authorized*

		  Parse.Cloud.useMasterKey();

		  // Query for the user to be modified by username
		  // The username is passed to the Cloud Function in a 
		  // key named "username". You can search by email or
		  // user id instead depending on your use case.

		  var query = new Parse.Query(Parse.User);
		  //query.equalTo("username", request.params.username);
		  query.equalTo("objectId", req.query.objectId);		  

  		console.log('hello7');
		
		  // Get the first user which matches the above constraints.
		  query.first({
		    success: function(anotherUser) {
		     			console.log('hello8',anotherUser);
			  // Successfully retrieved the user.
		      // Modify any parameters as you see fit.
		      // You can use request.params to pass specific
		      // keys and values you might want to change about
		      // this user.
		      anotherUser.set("inviteCounter", 2);

		      // Save the user.
		      anotherUser.save(null, {
		        success: function(anotherUser) {
		          // The user was saved successfully.
		          response.success("Successfully updated user.",anotherUser);
		        },
		        error: function(gameScore, error) {
		          // The save failed.
		          // error is a Parse.Error with an error code and description.
		          response.error("Could not save changes to user.",gameScore,error);
		        }
		      });
		    },
		    error: function(error) {
		      response.error("Could not find user.",error);
		    }
		  });
		});

		console.log('hello1');
		
		Parse.Cloud.run('modifyUser', { objectId: request.query.objectId }, {
		  success: function(status) {
			  		console.log('hello2');
		    // the user was updated successfully			
			
		  },
		  error: function(error) {
			  		console.log('hello3', error);
		    // error
		  }
		});
		
		
		
		/*
		//var query = new Parse.Query(Parse.User);
		var User = Parse.Object.extend("User");
		var query = new Parse.Query(User);
		
		
		query.equalTo("objectId", req.query.objectId);
		//query.equalTo("username", "zohaib" );		
		query.first({
		  success: function( user ) {
			  var op = {
					 	  "req.query.objectId" : req.query.objectId, 
						  "user " : user
					  	};

			if( user.inviteCounter != undefined && user.inviteCounter != null )
			user.inviteCounter += 1;
			else
			user.inviteCounter = 1;
			
			console.log("Before save");
			
			user.set("inviteCounter", (user.get('inviteCounter') + 1) );

			  user.save().then(function() {
			  //success: function(userAgain) {
				  console.log("Before save2 userAgain");
				  
	  			op.inviteCounterR = user.inviteCounter;
		
	  			console.log( JSON.stringify( op )  );
		
	  			res.jsonp( op );			
			  });
			
			
		  } ,
		  error: function(error) {
			console.log('error',error);
		  }
		});
		*/
	
	});
	


}//.setup class end