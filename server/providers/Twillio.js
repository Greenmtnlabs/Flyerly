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
    console.log('Twillio');
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

                // Var for Twilio models
                var Twillio = require(__dirname + '/../models/Twillio');


                // Check the number in the Database
                Twillio.findOne({
                    status: 'FREE'
                }, function(err, obj) {

                    if (err) {
                        responseJSON.status = 'FAIL';
                        res.jsonp(200, responseJSON);
                        return;
                    }

                    // If the number found in db
                    if (obj != null) {

                        // Set the property of object
                        obj.status = 'IN_USE';
                        obj.assignedTo = event._id;

                        // save Twillio event
                        obj.save(function(err, t) {

                            if (err) {
                                logger.error(JSON.stringify(err));
                                return;

                            }

                            responseJSON.status = 'OK';
                            responseJSON.message = 'Succesfully get the number';
                            responseJSON.eventID = event._id;
                            responseJSON.number = num.number;



                            // Response to request.
                            res.jsonp(200, responseJSON);
                        });


                        // If we request the server to new number
                    } else {

                        // Object of the model
                        var twillio = new Twillio();

                        // First request the api to get the number (testing)
                        var request = require('request');
                        request('http://192.168.0.117:3001/get-number', function(error, response, body) {

                            if (error) {
                                console.log(error);
                            }
                            if (!error && response.statusCode == 200) {

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
                                        logger.error(JSON.stringify(err));
                                        return;

                                    }

                                    responseJSON.status = 'OK';
                                    responseJSON.message = 'Succesfully get the number';
                                    responseJSON.eventID = event._id;
                                    responseJSON.number = num.number;


                                    // Response to request.
                                    res.jsonp(200, responseJSON);
                                });
                            }
                        });


                    }



                });


            });

        } else {

            responseJSON.status = 'FAIL';
            responseJSON.message = 'Sorry ! try again';
            // Response to client.
            res.jsonp(200, responseJSON);
        }




    });

}
