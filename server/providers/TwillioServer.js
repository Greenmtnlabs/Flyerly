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
     * Initial greetings.
     */
    app.post('/ut-handle-call', function(req, res) {

        // Get the number we are being called from.
        //var callerId = req.body.From;

		logger.info('inside ut-handle-call');
		logger.info('=========== REQUEST BODY ===========');
		logger.info(req.body);
		var response =
	            "<Response>\
						<Play>/audio/voice.wav</Play>\
							<Gather action='/handle-keypress' method='GET' timeout='5'>\
								<Say>Press 1 to forward this call</Say>\
							</Gather>\
							<Say>We didn't receive any input. Goodbye!</Say>\
					</Response>";

	   	res.writeHead(200, {
	            'Content-Type': 'text/xml'
	        });
	 	res.end(response);		
		
    });

	app.get('/handle-keypress', function(req, res) {
		
		logger.info('inside handle-keypress');
		logger.info('Digits = ' + req.query.Digits);

		if ( req.query.Digits == '1' ) {
		
		var response =
			"<Response>\
    			<Dial action='/handle-forward-call-status' method='POST' timeout='10'>\
					+9223222569865\
    			</Dial>\
    			<Say>I am unreachable</Say>\
				</Response>";
			
			res.writeHead(200, {
	            'Content-Type': 'text/xml'
	        });
	 		res.end(response);
			
		} else {

			var response =		
					"<Response><Say>You entered " + req.query.Digits + "</Say></Response>";

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
		logger.info('=========== REQUEST BODY 1 ===========');
		logger.info(req.body);
		
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


    /**
     * Client capabilities incoming.
     */
    app.get('/client-capability-token-twiml', function(req, res) {
        var twilio = require('twilio');
        var capability = new twilio.Capability(config.twilio.accountSid, config.twilio.authToken);

        capability.allowClientIncoming(req.query.user);

        res.writeHead(200, {
            'Content-Type': 'text/html'
        });
        res.end(capability.generate(config.twilio.tokenExpiry));
    });

}
