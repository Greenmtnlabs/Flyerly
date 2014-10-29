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

	
	// Save event using following steps
	//1-If recording exist then upload file, 2-then save event, 3-then work for twilio number, 4- return response.
    app.all('/event/save', function(req, res) {
		// Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

        // Construct response JSON
        var responseJSON = {};
		var recordingFileName = "";		
		var file1 = req.files.recording;
		var eventId = req.body.eventId;		
        var params = req.body;

		if( params.emergencyContacts ) {
			params.emergencyContacts	= JSON.parse( params.emergencyContacts );
		}
		params = {
			userId: params.userId,
			paid:  params.paid,
			
			timezoneOffset: params.timezoneOffset,
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
		
		print( ["in events65- params"+__line+": ", params] );
		
		function retError1( res, eventId, error, lineNum, message ) {
			responseJSON = {};
			responseJSON.status = 'FAIL';
			responseJSON.eventId = eventId;			
			responseJSON.message = message;
			responseJSON.message4Dev = "Error: Event.js, line#: "+lineNum+", error: " + JSON.stringify(error);

			//Log event
	        logger.error( responseJSON.message4Dev );
			print( responseJSON );
			
	    	// Response to request.
	        res.jsonp(200, responseJSON);
		}
	
		function retSuccess1( res, eventId, twillioNumber , line ) {
			responseJSON = {};
			responseJSON.status = 'OK';
			responseJSON.eventId = eventId;
	        responseJSON.twillioNumber = twillioNumber;			
	        responseJSON.message = 'Succesfully saved';
			

			print( responseJSON  );
			

	    	// Response to request.
			res.jsonp(200, responseJSON);

		}
		
		function print( msg ){
			console.log( msg );
		}
		
		
		//3-then work for twilio number, 4- return response.
		function checkTwilioNumberAndReturn() {
		
			if( params.twillioNumber != "" ){
				retSuccess1( res, params.eventId, params.twillioNumber , __line);
			} else
			{
			
				// Var for Twilio models
		        var Twillio = require(__dirname + '/../models/Twillio');		

		        // Check the number in the Database
		        Twillio.findOne({
		            status: 'FREE'
		        }, function(error, obj) {

		            if ( error ) {
		                retError1( res, params.eventId, error, __line, "Forwarding numbers not available. Please contact abdul.rauf@riksof.com");
		            }						
		            else if( obj != null ) {
				
						logger.info('Twillio number found in Db');
                
						// Set the property of object
		                obj.status = 'IN_USE';
		                obj.assignedTo = params.eventId;

		                // save Twillio event
		                obj.save(function(error, t) {

		                    if (error) {
								retError1( res, params.eventId,  error, __line, "Error in updating status of forwarding number. Please contact abdul.rauf@riksof.com");
		                    } else {
								retSuccess1( res, params.eventId, obj.number , __line);
							}
		                });
		            }
					else {								
						retError1( res, params.eventId,  "number_unavailable" , __line, 'No Twillio number found. Please contact abdul.rauf@riksof.com');
		            } // end of else
						
			
		        });
			}
		}
		
		//2-then update event, 
		function saveEvent() {
		
	        // Var for Events models
	        var Events = require(__dirname + '/../models/Events');
		
			if ( eventId ) {
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
							retError1( res, "0", err, __line, "Error in event update." );
	                    }
						else{
							params.eventId	= eventId;
	                    	checkTwilioNumberAndReturn();
						}
					}
				);
			}
			else {
		        var event = new Events( params );
				event.save(function (error) {
					params.eventId	= event._id;
	            	checkTwilioNumberAndReturn();
				});
			}
		
		} //End functions
		
		//1-If recording exist then upload file
		if( file1 == undefined ) {
			saveEvent();
		}
		else{
			//Upload file
			fs = require("fs");
			recordingFileName  = file1.name;
			
	        fs.rename(
			  file1.path, 
			  (config.dir.recordingsPath + recordingFileName), 
			  function (error) {

				 if (error) {
					retError1( res, "0", error,  __line, "Error in saving recording file." );
	             } else {            	
					saveEvent();
	             }				 
	        });
		}

    }); // end post
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// TESTING CODE  ----------------{-------
	
	app.all('/test-CommonFunctions', function(req, res) {		
		var CommonFunctions = require( __dirname + '/CommonFunctions' );
		CommonFunctions.print( "CommonFunctions.print: hello print");
		res.jsonp({"__line":__line});
				
	});
	
	
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

	// TESTING CODE  ----------------}-------		
	

}
