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

		function retError1( res, error, lineNum ) {
			var responseJSON = {};
			responseJSON.status = 'FAIL';
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
		   	 
		print("CL-Line#66 event obj: ", event); 
		
        // If Object is not null
        if ( event.userId ) {
			
			
			event.save(function (error) {
				
				print("CL-Line#66 event obj: ", event); 
				
                if (error) {
					retError1( res, error, 70);
                } 
				else {
					retSuccess1( res, event._id, twilioTestingNumber , 98);
					
					/*
	                
					// Var for Twilio models
	                var Twillio = require(__dirname + '/../models/Twillio');
					var twillio = new Twillio();
	                // Check the number in the Database
	                twillio.findOne({
	                    status: 'FREE'
	                }, function(error, obj) {

	                    if ( error ) {
	                        retError1( res, error, 83);
	                    }						
	                    else if( obj != null ) {
	                        // Set the property of object
	                        obj.status = 'IN_USE';
	                        obj.assignedTo = event._id;

	                        // save Twillio event
	                        obj.save(function(error, t) {

	                            if (error) {
									retError1( res, error, 112);
	                            } else{
									retSuccess1( res, event._id, obj.number , 114);
								}
	                        });


	                        // If we request the server to new number
	                    }
						//Rufi created code for obj == null						
	                    else if( obj == null ) {
							
							twillio.number		= twilioTestingNumber;
	                        twillio.status 		= 'IN_USE';
	                        twillio.assignedTo 	= event._id;
							
				            twillio.save(function(error, e) {
				
				                if (error) {
									retError1( res, error, 95);
				                } 
								else { 
									retSuccess1( res, event._id, twillio.number , 98);
									 }
							});
							
						}
						else {

	                        // Object of the model
	                        var twillio = new Twillio();

	                        // First request the api to get the number (testing)
	                        var request = require('request');
	                        request(config.urls.getForwadingNumUrl, function(error, response, body) {

	                            if( error ){
	                                retError1( res, error, 131);
	                            }
								else if ( response.statusCode != 200 ) {
									retError1( res, "error3 in Twillio.js: response.statusCode != 200", 134);
									
								}
								else if ( response.statusCode == 200 ) {

	                                var num = JSON.parse(response.body);
	                                console.log(num.number);

	                                // Get today date
	                                var today = new Date();

	                                // Add 29 days
	                                var numberOfDaysToAdd = 29;
	                                //today.setDate(today.getDate() + numberOfDaysToAdd);

	                                // Set the values of twillio account
	                                twillio.number = num.number;
	                                twillio.status = 'IN_USE';
	                                twillio.validityTime = today.getTime();
	                                twillio.assignedTo = event._id;

	                                // save Twillio event
	                                twillio.save(function(err, twillio) {

	                                    if (err) {
	                                        retError1( res, error, 159);
	                                    }
										else {
		                                    retSuccess1( res, eventID, number , 162);
										}
										
	                                });
									
	                            }
								
								
	                        });


	                    }
									
						
	                });
					
					*/
				}
            });

        } 		
		else{
			console.log("CL-Line#194, params data: ", data);			
			retError1( res, "userId not found", 183 );
		}
		
    });

}
