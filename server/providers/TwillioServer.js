/**
 * This module is responsible for handling Twilio Server for calling
 * @mraheelmateen
 */
// Reference to the module to be exported
TwillioServer = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
TwillioServer.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

    /**
     * Call handler
     */
    app.post('/ut-handle-call', function(req, res) {

        // Get the number we are being called from.
        var data = req.body;

        logger.info('inside ut-handle-call');
        logger.info('=========== REQUEST BODY 1 ===========');
        logger.info(data);
        logger.info('=========== REQUEST BODY 1 END ===========');

        if (data.To != null && data.To != '' && data.From != null && data.From != '') {

            var Twillio = require(__dirname + '/../models/Twillio');
            var Events = require(__dirname + '/../models/Events');
            var callTo = data.To;
            var callFrom = data.From;

            logger.info('CallTo: ' + callTo);
            logger.info('callFrom: ' + callFrom);


            Twillio.findOne({
                number: callTo,
				status : { $in: ["IN_USE", "N_USE_DEFAULT1"] }
            }, function(error, twillio) {

                if (error) {
                    var response =
                        "<Response>\
														<Say>Sorry, user is unreachable!</Say>\
													</Response>";
                    res.writeHead(200, {
                        'Content-Type': 'text/xml'
                    });
                    res.end(response);
                    return;
                }

                // if twillio object is found for this number
                if (twillio != null) {

                    logger.info('Twillio object found for number: ' + callTo);
                    Events.findOne({
                        _id: twillio.assignedTo
                    }, function(error, event) {

                        if (error) {
                            var response =
                                "<Response>\
														<Say>Sorry, user is unreachable!</Say>\
													</Response>";
                            res.writeHead(200, {
                                'Content-Type': 'text/xml'
                            });
                            res.end(response);
                            return;
                        }
                        // if event found for this number
                        if (event != null) {

                            logger.info('Event object found for number');

                            var file = event.recording;
                            var found = false;

                            // iterate over emergencyContacts list
                            for (i in event.emergencyContacts) {
                                if (event.emergencyContacts[i] == callFrom) {

                                    found = true;
                                    break;
                                }
                            }

                            // callFrom/caller found in emergencyContacts list
                            if (found) {

                                logger.info('Caller number found in event emergencyContacts: ' + callFrom);

                                var response =
                                    "<Response>\
													<Play>/recordings/" + file + "</Play>\
														<Gather action='/handle-keypress?emergencyNumber="+ event.emergencyNumber +"' method='POST' timeout='5'>\
															<Say>Press 1 to forward this call</Say>\
														</Gather>\
														<Say>We didn't receive any input. Goodbye!</Say>\
												</Response>";

                            } else {

                                logger.info('Caller not found in event emergencyContacts');

                                var response =
                                    "<Response>\
														<Play>/recordings/" + file + "</Play>\
													</Response>";
                            }

                            res.writeHead(200, {
                                'Content-Type': 'text/xml'
                            });
                            res.end(response);


                        } else {

                            logger.info('Sorry! no Event db object found');

                            var response =
                                "<Response>\
														<Say>No Untechable found!</Say>\
													</Response>";
                            res.writeHead(200, {
                                'Content-Type': 'text/xml'
                            });
                            res.end(response);
                        }

                    });


                } else {

                    logger.info('Sorry! no Twillio db object found');
                    var response =
                        "<Response>\
														<Say>No Untechable found!</Say>\
													</Response>";
                    res.writeHead(200, {
                        'Content-Type': 'text/xml'
                    });
                    res.end(response);
                }

            });


        } else {

			var response =
                        "<Response>\
														<Say>No Untechable found!</Say>\
													</Response>";
                    res.writeHead(200, {
                        'Content-Type': 'text/xml'
                    });
                    res.end(response);

		}

    });

    // key press handler
    app.post('/handle-keypress', function(req, res) {

        logger.info('inside handle-keypress');
        
		var Digits =req.body.Digits;
		var emergencyNumber = req.query.emergencyNumber;
		
		logger.info('Digits = ' + Digits);
		logger.info('emergencyNumber = ' + emergencyNumber);
		
        if (Digits == '1') {

            var response =
                "<Response>\
    			<Dial action='/handle-forward-call-status' method='POST' timeout='10'>\
					" + emergencyNumber + "\
    			</Dial>\
    			<Say>I am unreachable</Say>\
				</Response>";

            res.writeHead(200, {
                'Content-Type': 'text/xml'
            });
            res.end(response);

        } else {

            var response =
                "<Response><Say>You entered wrong digit</Say></Response>";

            res.writeHead(200, {
                'Content-Type': 'text/xml'
            });
            res.end(response);
        }
    });



    /**
     * Handle forward call
     */
    app.post('/handle-forward-call-status', function(req, res) {

        logger.info('inside handle-forward-call-status');
        logger.info('=========== REQUEST BODY 2 ===========');
        logger.info(req.body);
        logger.info('=========== REQUEST BODY 2 END ===========');

    });

    /**
     * Connecting to an agent.
     */
    app.post('/dial-tone-twiml', function(req, res) {
        // Queue the call
        var response =
            "<Response>\
					<Play>/audio/ringing.wav</Play>\
				</Response>";

        res.writeHead(200, {
            'Content-Type': 'text/xml'
        });
        res.end(response);
    });

	// for twillio testing
	app.get('/', function(req, response) {

        var fs = require('fs');
        var path = require('path');

        var filePath = path.join(__dirname + '/../../public/index.html');

        fs.readFile(filePath, {
            encoding: 'utf-8'
        }, function(err, data) {
            if (!err) {
                response.writeHead(200, {
                    'Content-Type': 'text/html'
                });
                response.write(data);
                response.end();


            } else {
                response.end('ERROR: ' + err);
            }
        });
    });

}
