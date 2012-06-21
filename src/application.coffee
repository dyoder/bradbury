Content = Backbone.Model.extend 
  url: -> "/content/#{@id}.json"

Bradbury = Backbone.Router.extend
  routes:
      "documents/:name": "show"

  show: (name) ->
    article = new Content
      id: name
    article.fetch
      success: (article) ->
        article = article.toJSON()
        document.title = article.title
        $("#article").html("<h1>#{article.title}</h1><p>#{article.body}</p>")
    
$(document).ready ->
  new Bradbury()
  Backbone.history.start()
