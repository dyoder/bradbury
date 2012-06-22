Article = Backbone.Model.extend 

  # url: -> "http://content-rocket-ly.commondatastorage.googleapis.com/#{@id}.json"
  url: "/content/hello-world.json"

Show = Backbone.View.extend

  initialize: ->
    self = @
    @model.on "change", -> self.render()
    @template = _.template($("##{@$el.attr('id')}-template").html())

  render: ->
    article = @model.toJSON()
    document.title = article.title
    $(@el).html(@template(article))
    return @

Bradbury = Backbone.Router.extend

  routes:
      "documents/:name": "show"

  show: (name) ->
    article = new Article({id:name})
    view = new Show({el: "#article", model: article})
    article.fetch()        
                  
$(document).ready ->
  new Bradbury()
  Backbone.history.start()
