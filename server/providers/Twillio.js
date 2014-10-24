/**
 * This module is responsible for handling Events Operations.
 * Assigned the twillio number and save that number in a database
 * for given appropriate userId
 * @mraheelmateen 
 */
// Reference to the module to be exported
Twillio = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
Twillio.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');
    
	// Get the request
    app.get('/get-forwading-number', function(req, res) {

		function retError1( res, error, lineNum, code ) {
			var responseJSON = {};
			responseJSON.status = 'FAIL';
			responseJSON.code = code;
			responseJSON.message = JSON.stringify(error);
			responseJSON.message4Dev = "Error: Twillio.js, twillio.save line#: "+lineNum+", error: " + responseJSON.message;
	        logger.error( responseJSON.error4Dev );
	        res.jsonp(200, responseJSON);
		}
	
		function retSuccess1( res, eventID, number , line) {
			var responseJSON = {};
			responseJSON.status = 'OK';
	        responseJSON.message = 'Succesfully get the number';
	        responseJSON.message4Dev = "Success: Twillio.js, twillio.save line#: "+line;
			responseJSON.eventID = eventID;
	        responseJSON.number = number;
	    	// Response to request.
			res.jsonp(200, responseJSON);
		}
		
		function print( msg ){
			console.log( msg );
		}
		
		
		var twilioTestingNumber = "+16464551382";
		
	    // Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

        // Var for Events models
        var Events = require(__dirname + '/../models/Events');

		var params  = req.query;

        // Object of the model
        var event = new Events( {
					  "userId" : params.userId
					});
		   	 
		console.log("CL-Line#"+__line+" event obj: ", event); 
		
        // If Object is not null
        if ( event.userId ) {
			
			
			event.save(function (error) {
				
				console.log("CL-Line#"+__line+" event obj: ", event); 
				
                if (error) {
					retError1( res, error, __line, "E1");
                } 
				else {
					
					logger.info('Event created successfully');	
					
					// Var for Twilio models
	                var Twillio = require(__dirname + '/../models/Twillio');
					//var twillio = new Twillio();
	                // Check the number in the Database
	                Twillio.findOne({
	                    status: 'FREE'
	                }, function(error, obj) {

	                    if ( error ) {
	                        retError1( res, error, __line, "E2");
	                    }						
	                    else if( obj != null ) {
							
							logger.info('Twillio number found in Db');
	                        
							// Set the property of object
	                        obj.status = 'IN_USE';
	                        obj.assignedTo = event._id;

	                        // save Twillio event
	                        obj.save(function(error, t) {

	                            if (error) {
									retError1( res, error, __line, "E3");
	                            } else{

									logger.info('Twillio number updated successfully');
									retSuccess1( res, event._id, obj.number , __line);
								}
	                        });


	                        // If we request the server to new number
	                    }
						else {
							
							retError1( res, 'No Twillio number found. Please contact abdul.rauf@riksof.com', __line, "number_unavailable");
							
							// Object of the model
	                       /* var twillio = new Twillio();

							//require the Twilio module and create a REST client 
							var client = require('twilio')(config.twilio.accountSid, config.twilio.authToken); 
							logger.info('Get new number from Twillio');
	                        // create a new number 
							client.incomingPhoneNumbers.create({
								 voiceUrl: config.urls.TWILLIO_CALL_URL,
								 voiceMethod: "POST",
								 areaCode: "646"
							     		                  
							}, function(err, number) {
	                            if( error ){
	                                retError1( res, error, __line);
	                            } else {

									var twillioNumber = number.phone_number;
									logger.info('New Twillio number is: ' + twillioNumber);
									logger.info('New Twillio number sid is: ' + number.sid);

	                                // Get today's date
	                                var today = new Date();
					
	                                // Add 29 days
	                                var numberOfDaysToAdd = 29;
	                                today.setDate(today.getDate() + numberOfDaysToAdd);

	                                // Set the values of twillio account
	                                twillio.number = twillioNumber;
									twillio.sId = number.sid;
	                                twillio.status = 'IN_USE';
	                                twillio.validityTime = today.getTime();
	                                twillio.assignedTo = event._id;

	                                // save Twillio event
	                                twillio.save(function(err, twillio) {

	                                    if (err) {
	                                        retError1( res, error, __line);
	                                    }
										else {
	
											logger.info('New Twillio number saved successfully');
		                                    retSuccess1( res, event._id, twillioNumber , __line);
										}
										
	                                });
								
								}// end of else from twillio 
									
	                        });*/


	                    } // end of else
									
						
	                });
					
					
				}

            }); // event save

        } 		
		else{
			console.log("CL-Line#182, params data: ", params);			
			retError1( res, "userId not found", __line , "E5");
		}
		
    });

}
