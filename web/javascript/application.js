(function() {
  var Bradbury, Content;

  Content = Backbone.Model.extend({
    url: function() {
      return "/content/" + this.id + ".json";
    }
  });

  Bradbury = Backbone.Router.extend({
    routes: {
      "documents/:name": "show"
    },
    show: function(name) {
      var article;
      article = new Content({
        id: name
      });
      return article.fetch({
        success: function(article) {
          article = article.toJSON();
          document.title = article.title;
          return $("#article").html("<h1>" + article.title + "</h1><p>" + article.body + "</p>");
        }
      });
    }
  });

  $(document).ready(function() {
    new Bradbury();
    return Backbone.history.start();
  });

}).call(this);
