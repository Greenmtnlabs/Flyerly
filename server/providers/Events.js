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
    app.post('/event/save', function(req, res) {
		
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
		
        // Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

        // Construct response JSON
        var responseJSON = {};

        // Var for Events models
        var Events = require(__dirname + '/../models/Events');

        var params = req.body;
		if( params.emergencyContacts ){
			params.emergencyContacts	= JSON.parse( params.emergencyContacts );
		}

		params = {
			eventId: params.eventId,
			userId: params.userId,
			spendingTimeTxt: params.spendingTimeTxt,
		    startTime: params.startDate,
		    endTime: params.endDate,
			hasEndDate: hasEndDate,
		    location: location,
			forwardingNumber: params.forwardingNumber,
		    emergencyNumbers: params.emergencyNumbers,
			emergencyContacts: params.emergencyContacts,
			hasRecording: params.hasRecording
		};


        console.log( "params: ", params.eventId );


        if ( params.eventId ) {
            // update for the given event 
            Events.update({
                    _id: params.eventId
                }, {
                    // Set the values of request to event and update
                    $set: params
                }, {
                    safe: true,
                    upsert: true
                },
                function(err, model) {

                    if (err) {
                        logger.error(JSON.stringify(err));
                        return;
                    }

                    // add message to log
                    logger.info('Event updated successfully');

                    // response to call
                    res.json(200, {
                        status: "OK",
                        eventId: eventId
                    });
                });

        }
		else{
			
		}


    }); // end post
	
	
	
	/// Test save event
	console.log('save1-live, config.http.host: ',config.http.host);

	function save(req,res){
		console.log('/save1');

		if( req.body.emergencyContacts )
		req.body.emergencyContacts	= JSON.parse( req.body.emergencyContacts );
		
		/*
		for(var attributename in emergencyContacts){
		    console.log(attributename+": "+emergencyContacts[attributename]);
		}
		*/
		
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
	
	app.all('/test-CommonFunctions', function(req, res) {		
		var CommonFunctions = require( __dirname + '/CommonFunctions' );
		CommonFunctions.print( "CommonFunctions.print: hello print");
		res.jsonp(__line);
				
	});
	

}
