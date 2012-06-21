(function() {
  var Bradbury;

  Bradbury = {
    Models: {},
    Controllers: {},
    Views: {}
  };

  Bradbury.Models.Document = Backbone.Model.extend({
    url: function() {}
  });

  console.log(Backbone);

  Bradbury.Controllers.Documents = Backbone.Router.extend({
    routes: {
      "documents/:name": "show"
    },
    show: function(name) {
      return $("#name").text(name);
    }
  });

  $(document).ready(function() {
    new Bradbury.Controllers.Documents();
    Backbone.history.start();
    return console.log("bradbury started ...");
  });

}).call(this);
