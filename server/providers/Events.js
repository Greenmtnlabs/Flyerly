/**
 * This module is responsible for handling Events Operations.
 * For Update the data for certain event which is received after number assigned
 * @mraheelmateen
 */
// Reference to the module to be exported
Events = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
Events.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

	
	// Get the request
    app.all('/event/save', function(req, res) {
		
		function retError1( res, error, lineNum ) {
			var responseJSON = {};
			responseJSON.status = 'FAIL';
			responseJSON.message = JSON.stringify(error);
			responseJSON.message4Dev = "Error: Twillio.js, twillio.save line#: "+lineNum+", error: " + responseJSON.message;

			//Log event
	        logger.error( responseJSON.message4Dev );
	    	// Response to request.
	        res.jsonp(200, responseJSON);
		}
	
		function retSuccess1( res ) {
			var responseJSON = {};
			responseJSON.status = 'OK';
	        responseJSON.message = 'Event updated successfully.';
			
	    	// Response to request.
			res.jsonp(200, responseJSON);
		}
		
		function print( msg ){
			console.log( msg );
		}
		
		print( "req.body: ", req.body );
		
        // Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

        // Construct response JSON
        var responseJSON = {};

        var eventId = req.body.eventId;
		
        if ( eventId ) {
			
			//1-If recording exist then upload file, 2-then update event, 3-then return response.
			var recordingFileName = "";
			
			//2-then update event, 3-then return response.
			function updateEventAndRetResponse() {
				
		        // Var for Events models
		        var Events = require(__dirname + '/../models/Events');
		
		        var params = req.body;

				if( params.emergencyContacts ){
					params.emergencyContacts	= JSON.parse( params.emergencyContacts );
				}
				params = {
					userId: params.userId,
			
					spendingTimeTxt: params.spendingTimeTxt,
				    startTime: params.startDate,
				    endTime: params.endDate,
					hasEndDate: params.hasEndDate,
		    

					twillioNumber: params.twillioNumber,
					location: params.location,
				    emergencyNumber: params.emergencyNumber,
					emergencyContacts: params.emergencyContacts,
					hasRecording: params.hasRecording,
					recording: recordingFileName,
			
					socialStatus: params.socialStatus,
					fbAuth: params.fbAuth,
					twitterAuth: params.twitterAuth,
					linkedinAuth: params.linkedinAuth,
			
					email: params.email,
					password: params.password,
					respondingEmail: params.respondingEmail
				};
				
	            // update for the given event 
	            Events.update({
	                    _id: eventId
	                }, {
	                    // Set the values of request to event and update
	                    $set: params
	                }, {
	                    safe: true,
	                    upsert: true
	                },
	             	function(err, model) {
						
	                    if (err) {
							retError1( res, err, __line );
	                    }
						else{
	                    	retSuccess1( res );
						}
					}
				);
				
			} //End functions
			
			
			
			var file1 = req.files.recording;
			//var profileImageDir  = __dirname+'/../../recordings/'; //config.dir.recordingsPath
			
			if( file1 != undefined ) {
				fs = require("fs");
				recordingFileName  = file1.name;
		
				//Upload file
		        fs.rename(
				  file1.path, 
				  (config.dir.recordingsPath + recordingFileName), 
				  function (error) {

					 if (error) {
						retError1( res, error, __line );
		             } else {            	
						updateEventAndRetResponse();
		             }				 
		        });
			}
			else{
				updateEventAndRetResponse();
			}
        }
		else{
			retError1( res, "eventId not found.", __line );
		}

    }); // end post
	
	app.all('/test-CommonFunctions', function(req, res) {		
		var CommonFunctions = require( __dirname + '/CommonFunctions' );
		CommonFunctions.print( "CommonFunctions.print: hello print");
		res.jsonp(__line);
				
	});
	
	/*
	function save(req,res){
		console.log('/save1');

		if( req.body.emergencyContacts )
		req.body.emergencyContacts	= JSON.parse( req.body.emergencyContacts );
		
		//for(var attributename in emergencyContacts){
		  //  console.log(attributename+": "+emergencyContacts[attributename]);
		//}
	
		var responseJSON = {
            status: "OK",
			testObj:{a:1, 2:'b', c:"3"},
			testAry:["a","b"],			
			reqBod: req.body,
			reqQuery: req.query,
			reqFiles: req.files

        };
		
		function retResponse(){			
	        res.json(200, responseJSON);
		}
		
		
		fs = require("fs");
		
		var profileImageDir  = __dirname+'/../../recordings/';
		var file1 = req.files.recording;
		if( file1 != undefined ) {
			var photoName  = file1.name;
		
			//Rename uploaded file
	        fs.rename(
			  file1.path, 
			  profileImageDir + photoName, 
			  function (error) {

				 if (error) {
					responseJSON.msg = 'Error: '+err;
			        res.json(200,responseJSON);
	             } else {
            	
					responseJSON.msg = 'File uploaded successfully, updating profile.';
					retResponse();
	             }
				 
	        });
		}
		else{
			responseJSON.msg = 'File not found for upload.';
			retResponse();
		}
		
        
		
	}
	app.all('/save1', function(req, res) {
		save(req,res);
	});
	*/
	

}
