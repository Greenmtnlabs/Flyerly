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

	/*
	// Get the request
    app.post('/event/save', function(req, res) {

        // Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

        // Construct response JSON
        var responseJSON = {};

        // Var for Events models
        var Events = require(__dirname + '/../models/Events');

        var data = req.body;

        // Get the event id from request
        var eventId = data.eventId;

        console.log( "eventId: ", eventId );


        if ( data ) {
            // update for the given event 
            Events.update({
                    _id: eventId
                }, {
                    // Set the values of request to event and update
                    $set: {
                        userId: data.userId,
						spendingTimeTxt: data.spendingTimeTxt,
                        startTime: data.startDate,
                        endTime: data.endDate,
						hasEndDate: hasEndDate,
                        location: location,
						forwardingNumber: data.forwardingNumber,
                        emergencyNumbers: data.emergencyNumbers,
						emergencyContacts: data.emergencyContacts,
						hasRecording: data.hasRecording
                    }
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

        } //end if 


    }); // end post
	*/
	
	
	/// Test save event
	console.log('save1-live, config.http.host: ',config.http.host);

	function save(req,res){
		console.log('save1-in');
		
		var responseJSON = {
            status: "OK",
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
	

}
