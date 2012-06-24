(function() {
  var Article, Articles, Bradbury, Editor, Reader;

  Article = Backbone.Model.extend({
    url: "/content/hello-world.json"
  });

  Articles = Backbone.Collection.extend({
    model: Article,
    get: function(name) {
      var article;
      if (article = this._get(name)) {
        Bradbury.nextTick(function() {
          return article.trigger("ready");
        });
      } else {
        article = this.load(name);
      }
      return article;
    },
    load: function(name) {
      var article;
      article = new Article({
        id: name
      });
      article.fetch({
        success: function() {
          return article.trigger("ready");
        }
      });
      this.push(article);
      return article;
    },
    _get: function(name) {
      return Backbone.Collection.prototype.get.call(this, name);
    }
  });

  Reader = Backbone.View.extend({
    initialize: function() {
      return this.template = _.template($("#" + (this.$el.attr('id')) + "-template").html());
    },
    attach: function(model) {
      if (this.model) this.model.detach();
      this.model = model;
      return this.model.on("ready", this.render, this);
    },
    detach: function() {
      if (this.model) {
        this.model.off(null, null, this);
        return this.model = null;
      }
    },
    render: function() {
      var article;
      console.log("Rendering reader view");
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
      return this.template = _.template($("#" + (this.$el.attr('id')) + "-editor-template").html());
    },
    attach: function(model) {
      if (this.model) this.model.detach();
      this.model = model;
      return this.model.on("ready", this.render, this);
    },
    detach: function() {
      if (this.model) {
        this.model.off(null, null, this);
        return this.model = null;
      }
    },
    render: function() {
      var article,
        _this = this;
      article = this.model.toJSON();
      document.title = article.title;
      $(this.el).html(this.template(article));
      $("#textarea-body, #input-title").change(function() {
        return _this.save();
      });
      return this;
    },
    save: function() {
      return this.model.save(this.gather(), {
        success: function() {
          return Bradbury.alert("success", "Article saved.");
        },
        error: function() {
          return Bradbury.alert("error", "Unable to save your changes.");
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
    initialize: function() {
      this.articles = new Articles();
      this.reader = new Reader({
        el: "#article"
      });
      return this.editor = new Editor({
        el: "#article"
      });
    },
    show: function(name) {
      this.editor.detach();
      return this.reader.attach(this.articles.get(name));
    },
    edit: function(name) {
      this.reader.detach();
      return this.editor.attach(this.articles.get(name));
    },
    markdownToHTML: function(markdown) {
      if (this.converter == null) this.converter = new Markdown.Converter();
      return this.converter.makeHtml(markdown);
    }
  });

  Bradbury.alert = function(style, message) {};

  Bradbury.nextTick = function(fn) {
    return setTimeout(fn, 0);
  };

  $(document).ready(function() {
    window.Bradbury = new Bradbury();
    return Backbone.history.start();
  });

}).call(this);
