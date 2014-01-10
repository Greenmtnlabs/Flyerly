// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("mergeUser", function(request, response) {

  Parse.Cloud.useMasterKey();

  var oUser = new Parse.User();
  var status = -1;

  // Set your id to desired user object id
  oUser.id = request.params.oldUser;
  var newUser = request.params.newUser;

/*var inapps = new Parse.Query("InApp");

      		inapps.equalTo("user", oUser);

      		inapps.find().then(function(results) {

			if (status != -1) {
             			status = status + ' AND ';
          		}
			status = status + "Found " + results.length + " in apps for userId " + request.params.oldUser;
			
			var InAppR = Parse.Object.extend("InAppR");

			// this will store the rows for use with Parse.Object.saveAll
			var inAppArray = [];

			// create objects,
			for (var i = 0; i < results.length ; i++) { 
			      var newInApp = new InAppR();
			      newInApp.set("user", newUser);
			      newInApp.set("json", results[i].json);
			      inAppArray.push(newInApp);
			}

			Parse.Object.saveAll(inAppArray).then(function(){
			
				if (status != -1) {
             				status = status + ' AND ';
          			}
				
response.success(status);
		  			
			});
//response.success(status + " test ="+newInApp.get("user"));
});
*/





  var flyers = new Parse.Query("Flyer");

  flyers.equalTo("user", oUser);

  flyers.find().then(function(results) {

	var FlyerTest = Parse.Object.extend("FlyerTest");

        // this will store the rows for use with Parse.Object.saveAll
        var flayerArray = [];

      	status = "Found " + results.length + " flyers for userId " + request.params.oldUser;
	//status = "Found =" + results[i].file + " date = " + results[i].createdAt ;

        // create objects,
        for (var i = 1; i < results.length ; i++) { 
          var newFlayer = new FlyerTest();
          newFlayer.set("user", newUser);
          //newFlayer.set("image", results[i].image);
          flayerArray.push(newFlayer);
        }

        // save all the newly created objects
        Parse.Object.saveAll(flayerArray).then(function() {
	
		var inapps = new Parse.Query("InApp");

      		inapps.equalTo("user", oUser);

      		inapps.find().then(function(results) {

			if (status != -1) {
             			status = status + ' AND ';
          		}

			status = status + "Found " + results.length + " in apps for userId " + request.params.oldUser;
			
			var InAppR = Parse.Object.extend("InAppR");

			// this will store the rows for use with Parse.Object.saveAll
			var inAppArray = [];

			// create objects,
			for (var i = 0; i < results.length ; i++) { 
			      var newInApp = new InAppR();
			      newInApp.set("user", newUser);
			      newInApp.set("json", results[i].json);
			      inAppArray.push(newInApp);
			}

			Parse.Object.saveAll(inAppArray).then(function(){
			
				if (status != -1) {
             				status = status + ' AND ';
          			}

		  		response.success(status);	
			});
			
     			//response.success(status);
		});
			
	
	});
      
      //response.success(status);
  });

});
