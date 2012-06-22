(function() {
  var Article, Bradbury, Show;

  Article = Backbone.Model.extend({
    url: "/content/hello-world.json"
  });

  Show = Backbone.View.extend({
    initialize: function() {
      var self;
      self = this;
      this.model.on("change", function() {
        return self.render();
      });
      return this.template = _.template($("#" + (this.$el.attr('id')) + "-template").html());
    },
    render: function() {
      var article;
      article = this.model.toJSON();
      document.title = article.title;
      $(this.el).html(this.template(article));
      return this;
    }
  });

  Bradbury = Backbone.Router.extend({
    routes: {
      "documents/:name": "show"
    },
    show: function(name) {
      var article, view;
      article = new Article({
        id: name
      });
      view = new Show({
        el: "#article",
        model: article
      });
      return article.fetch();
    }
  });

  $(document).ready(function() {
    new Bradbury();
    return Backbone.history.start();
  });

}).call(this);
