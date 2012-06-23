(function() {
  var Article, Bradbury, Editor, Show;

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
    },
    edit: function() {
      return window.open("documents/:name/editor");
    }
  });

  Editor = Backbone.View.extend({
    initialize: function() {
      var self;
      self = this;
      this.model.on("change", function() {
        return self.render();
      });
      return this.template = _.template($("#" + (this.$el.attr('id')) + "-editor-template").html());
    },
    events: {
      "change": "save"
    },
    render: function() {
      var article;
      article = this.model.toJSON();
      document.title = article.title;
      $(this.el).html(this.template(article));
      return this;
    },
    save: function() {
      return this.model.save(this.gather(), {
        success: function() {
          return Bradbury.alert("success", "Article saved.");
        },
        error: function() {
          return console.log("Error saving document!");
        }
      });
    },
    gather: function() {
      return {
        title: this.$("#input-title").val(),
        body: this.$("#textarea-body").val()
      };
    }
  });

  Bradbury = Backbone.Router.extend({
    routes: {
      "documents/:name": "show",
      "documents/:name/editor": "edit"
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
    },
    edit: function(name) {
      var article, view;
      article = new Article({
        id: name
      });
      view = new Editor({
        el: "#article",
        model: article
      });
      return article.fetch();
    },
    markdownToHTML: function(markdown) {
      if (this.converter == null) this.converter = new Markdown.Converter();
      return this.converter.makeHtml(markdown);
    }
  });

  Bradbury.alert = function(style, message) {
    return $("#alerts").append("<div class='fade in alert alert-" + style + "'>" + message + "</div>");
  };

  $(document).ready(function() {
    window.Bradbury = new Bradbury();
    return Backbone.history.start();
  });

}).call(this);
