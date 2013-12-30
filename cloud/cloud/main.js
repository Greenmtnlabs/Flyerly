
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("mergeUser", function(request, response) {

  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("Flyer");

  query.equalTo("user", request.params.oldUser);

  query.find({
    success: function(results) {
      
      //response.success(request.params.oldUser);
      var status = "Found " + results.length + " flyers for userId " + request.params.oldUser;
      response.success(status);

    },

    error: function() {
      // response.error("No flyers exist for user.");
      status = "No flyers exist for userId " + request.params.oldUser; 
      response.error(status);
    }
  });
});
