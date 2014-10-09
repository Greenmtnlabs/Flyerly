/**
 * This module is responsible for handling Events Operations.
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

        // Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

        // Construct response JSON
        var responseJSON = {};

        // Var for Events models
        var Events = require(__dirname + '/../models/Events');

        // Object of the model
        var event = new Events();

        // Fetch the Get object
        var data = req.query;

        // If Object is not null
        if (data.userId) {

            // Set the User Id
            event.userId = data.userId;

            // save User event
            event.save(function(err, e) {
                if (err) {
                    logger.error(JSON.stringify(err));
                    return;

                }

                // Create Twillio object
                var accountSid = 'AC683a4ecfb2b5243f3039c92c3d86abf2';
                var authToken = 'b47ae8f8fb8ec78bb90c3e6e68bcd4f8';
                var client = require('twilio')(accountSid, authToken);

                client.incomingPhoneNumbers.create({
                    voiceUrl: "http://demo.twilio.com/docs/voice.xml",
                    phoneNumber: "+15005550006"
                }, function(err, number) {
                    if (err) {
                        console.log(JSON.stringify(err));
                        return;
                    }

                    // Var for Twilio models
                    var Twillio = require(__dirname + '/../models/Twillio');

                    // Object of the model
                    var twillio = new Twillio();

                    // Get today date
                    var today = new Date();

                    // Add 29 days
                    var numberOfDaysToAdd = 29;
                    today.setDate(today.getDate() + numberOfDaysToAdd);

                    // Set the values of twillio account
                    twillio.number = number.phoneNumber;
                    twillio.status = 'IN_USE';
                    twillio.validityTime = today.getTime();
                    twillio.assignedTo = event._id;

                    // save Twillio event
                    twillio.save(function(err, twillio) {

                        if (err) {
                            logger.error(JSON.stringify(err));
                            return;

                        }

                        responseJSON.status = 'OK';
                        responseJSON.message = 'Succesfully get the number';
                        responseJSON.eventID = event._id;
                        responseJSON.number = number.phoneNumber;



                        // Response to request.
                        res.jsonp(200, responseJSON);
                    });



                });


            });

        } else {

            responseJSON.status = 'FAIL';
            responseJSON.message = 'Sorry! that username is already taken';
            // Response to client.
            res.jsonp(200, responseJSON);
        }




    });
}
