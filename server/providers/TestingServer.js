/**
 * This module is responsible for handling Email( inbox ) Operations.
 */

// Reference to the module to be exported
TestingServer = module.exports = {};

/**
 * Setup takes an express application server and configures
 * it to handle errors.
 */
TestingServer.setup = function( app ) {
	
    

		// Post on twitter
	function postOnTwitter( str, access_token_key, access_token_secret) {
		// var Twitter = require('node-twitter');
		
		// 	var twitterRestClient = new Twitter.RestClient(
		// 	  	"GxQAvzs4YXBl2o39TN5nr4ogj",
		// 		"IRO1i1pqUdKorBg1fwn4SEzniAeG1GrzpUVXd9mooG4GkpIlNA",
		// 		access_token_key,
		// 		access_token_secret
		// 	);
			 
		// 	twitterRestClient.statusesUpdateWithMedia(
		// 	    {
		// 	        'status': str,
		// 	        'media[]': "https://i.ytimg.com/vi/ZYNwIfCb440/maxresdefault.jpg"
		// 	    },
		// 		function(error, result) {
		// 		    if (error)
		// 		    {
		// 		        console.log('Error: ' + (error.code ? error.code + ' ' + error.message : error.message));
		// 		    }
				 
		// 		    if (result)
		// 		    {   
		// 		        console.log(result);
		// 		    }
		// 		}
		// 	);


		

	}



	 app.get('/testTweet', function(req, res) {
	 	var twitter_update_with_media = require('./twitter_update_with_media');
 
		var tuwm = new twitter_update_with_media({
		  consumer_key: 'GxQAvzs4YXBl2o39TN5nr4ogj',
		  consumer_secret: 'IRO1i1pqUdKorBg1fwn4SEzniAeG1GrzpUVXd9mooG4GkpIlNA',
		  token: '1277491879-yxrariRIZms1v3ivcaZQJKXrVjTFLh6QjxipfNV',
		  token_secret: '3zkiS89S531xFW3L0OddOqqLumvEs6y8UlLugs3ExLdjE'
		});
	
		tuwm.post('This is #untechable', 'https://i.ytimg.com/vi/ZYNwIfCb440/maxresdefault.jpg', function(err, response) {
		  if (err) {		  	
		    console.log(err);
		    res.jsonp("erro occ");
		  } else {

		  	console.log(response);
		  	res.jsonp("success");
		  }
		});
	 });
	
	    
}
