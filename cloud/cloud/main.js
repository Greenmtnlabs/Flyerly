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


// Increase invite count
Parse.Cloud.define("increaseInviteCounter", function(request, response) {


  Parse.Cloud.useMasterKey();

  var query = new Parse.Query(Parse.User);
  query.equalTo("objectId", req.params.objectId);



  // Get the first user which matches the above constraints.
  query.first({
    success: function(anotherUser) {
	  // Successfully retrieved the user.
      // Modify any parameters as you see fit.
      // You can use request.params to pass specific
      // keys and values you might want to change about
      // this user.
      //anotherUser.set("inviteCounter", 2);
	  anotherUser.set("inviteCounter", (user.get('inviteCounter') + 1) );

      // Save the changes.
      anotherUser.save(null, {
        success: function(anotherUser) {
          // The user was saved successfully.
          response.success("1- Successfully updated user.",anotherUser);
        },
        error: function(gameScore, error) {
          // The save failed.
          // error is a Parse.Error with an error code and description.
          response.error("2- Could not save changes to user.",gameScore,error);
        }
      });
    },
    error: function(error) {
      response.error("3- Could not find user.",error);
    }
  });
});