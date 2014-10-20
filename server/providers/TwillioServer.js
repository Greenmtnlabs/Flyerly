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
        var callerId = req.body.From;

		var response =
	            "<Response>\
						<Play>/audio/PleaseWait.wav</Play>\
						<Play>/audio/waves.wav</Play>\
						<Leave />\
					</Response>";

	        res.writeHead(200, {
	            'Content-Type': 'text/xml'
	        });
	        res.end(response);		
			
			//When user has emergency number then after playing auto, give an option of press 1 to call for emergency,
			//When  user pressed 1 then call on emergency number
				
			var hasEmgNumber = false;
			if( hasEmgNumber ) {
				var  emergencyNumber = "client:raafay";
				
	            // Initiate call to the agent.
	            var client = require('twilio')(config.twilio.accountSid, config.twilio.authToken);

	            client.calls.create({
	                url: "http://www.riksof.com/agent-called-twiml",
	                to: emergencyNumber,
	                from: callerId,
	                timeout: 20
	            }, function(err, call) {
	                console.log('Call forwaded to emergency number: '+emergencyNumber);
	            });
			}        
    });



    /**
     * Connecting to an agent.
     */
    app.post('/agent-called-twiml', function(req, res) {
        // Queue the call
        var response =
            "<Response>\
					<Dial>\
						<Queue url='/dial-tone-twiml'>CallQueue</Queue>\
					</Dial>\
				</Response>";

        res.writeHead(200, {
            'Content-Type': 'text/xml'
        });
        res.end(response);
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
