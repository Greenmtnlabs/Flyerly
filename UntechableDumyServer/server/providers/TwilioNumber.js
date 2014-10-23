/**
 * This module is responsible for handling Events Operations.
 * Assigned the twillio number and save that number in a database
 * for given appropriate userId
 * @mraheelmateen
 */
// Reference to the module to be exported
TwillioNumber = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
TwillioNumber.setup = function(app) {

    // Get the configurations
    var config = require(__dirname + '/../config');

    // Our logger for logging to file and console
    var logger = require(__dirname + '/../logger');

    var myArray = new Array();
	myArray.push("12345");
	myArray.push("12346");
	myArray.push("12347");
	myArray.push("12348");
	myArray.push("12349");

    // Get the number
    app.all('/get-number', function(req, res) {
		
	console.log('insight get-number');

        // Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

        // Construct response JSON
        var responseJSON = {};

        // response to call
        res.json(200, {
            status : "OK",
	    number :myArray[0]
        });
	
		myArray.splice(0, 1);


    });

    // Release the number 
    app.get('/release-number', function(req, res) {

        // Our logger for logging to file and console
        var logger = require(__dirname + '/../logger');

	console.log('release number api');

        // Construct response JSON
        var responseJSON = {};

	 var data = req.query;
	
	console.log(data);
	
	var number = data.number;
	
	myArray.push( number );
	console.log(myArray);

        // response to call
        res.json(200, {
            status : "OK"
        });

    });

	
}
