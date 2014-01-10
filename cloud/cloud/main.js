
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("mergeUser", function(request, response) {

  Parse.Cloud.useMasterKey();

  var oUser = new Parse.User();
  var status = -1;

  // Set your id to desired user object id
  oUser.id = request.params.oldUser;

  var flyers = new Parse.Query("Flyer");

  flyers.equalTo("user", oUser);

  flyers.find({
    success: function(results) {
  
      status = "Found " + results.length + " flyers for userId " + request.params.oldUser;

    },

    error: function() {
   
      status = "Error in query finding flyers for user " + request.params.oldUser; 
      response.error(status);
    }
  }).then(;

  var inapps = new Parse.Query("InApp");

  inapps.equalTo("user", oUser);

  inapps.find({
    success: function(results) {
      
      if (status != -1) {
         status = status + ' AND ';
      }
 
      status = status + "Found " + results.length + " in apps for userId " + request.params.oldUser;
      
    },

    error: function() {
      
      status = "Error in query finding in apps for user " + request.params.oldUser; 
      response.error(status);
    }
  });

  response.success(status);

});
