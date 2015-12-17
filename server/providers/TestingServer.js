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
	
   
	app.get('/testLinkedIn', function(req, res) {

		var postRequest = [];
		var str = 'This is #untechable';
			var body = '<share>';
				body += '<comment>'+str+'</comment>';
				//body += '<image>'+ 'https://i.ytimg.com/vi/ZYNwIfCb440/maxresdefault.jpg'+'</image>';
				body += '<visibility>';
				body += '<code>anyone</code>';
				body += '</visibility>';
				body += '</share>';
			
			 	postRequest = {
				host: 'api.linkedin.com',
				port: 443,
				path: '/v1/people/~/shares?oauth2_access_token=' + 'AQUJav8o1zQTXNFeZVeCSiYcghdBM6sroaUSZd2w_z6uvB1Udzu66-ao2JV-zVolSZK2iP6egVwTWNpw0Hp2B-6Dau_4FThhMu4IjDwuH5LktohvDO3PeZdjBYOOduaHmQ0B7c0uRzphbydM340b1nO2YRdDdz6CJ_SoUcLkx7jNHHPxqII',
				method: "POST",
			    headers: {
			        'Cookie': "cookie",
			        'Content-Type': 'text/xml',
			        'Content-Length': Buffer.byteLength(body)
			    }
			};
		
			var buffer = "";
			var https = require('https');
		
			var req = https.request( postRequest, function( res ) {
	   
			   console.log("LinkedIn statusCode: "+ res.statusCode );		   
		   
			   buffer = "";
	   
			   res.on( "data", function( data ) {console.log("data"); });
			   res.on( "end",  function( data ) { console.log("end"); });
			});

			req.write( body );
			req.end();

	 });



	 // app.get('/testTweet', function(req, res) {
	 // 	var twitter_update_with_media = require('./twitter_update_with_media');
 
		// var tuwm = new twitter_update_with_media({
		//   consumer_key: 'GxQAvzs4YXBl2o39TN5nr4ogj',
		//   consumer_secret: 'IRO1i1pqUdKorBg1fwn4SEzniAeG1GrzpUVXd9mooG4GkpIlNA',
		//   token: '1277491879-yxrariRIZms1v3ivcaZQJKXrVjTFLh6QjxipfNV',
		//   token_secret: '3zkiS89S531xFW3L0OddOqqLumvEs6y8UlLugs3ExLdjE'
		// });
	
		// tuwm.post('This is testing #untechable', 'https://i.ytimg.com/vi/ZYNwIfCb440/maxresdefault.jpg', function(err, response) {
		//   if (err) {		  	
		//     console.log(err);
		//     res.jsonp("erro occ");
		//   } else {

		//   	console.log(response);
		//   	res.jsonp("success");
		//   }
		// });
	 // });
	
	    
}
