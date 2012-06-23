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
  
  edit: -> window.open("documents/:name/editor")

Editor = Backbone.View.extend

  initialize: ->
    self = @
    @model.on "change", -> self.render()
    @template = _.template($("##{@$el.attr('id')}-editor-template").html())

  events:
    "change": "save"
     
  render: ->
    article = @model.toJSON()
    document.title = article.title
    $(@el).html(@template(article))
    return @

  save: -> 
    @model.save @gather(),
      success: ->
        Bradbury.alert("success","Article saved.")
        
      error: -> console.log "Error saving document!"
    
  gather: ->
    title: @$("#input-title").val()
    body: @$("#textarea-body").val()

Bradbury = Backbone.Router.extend

  routes:
      "documents/:name": "show"
      "documents/:name/editor": "edit"
      
  show: (name) ->
    article = new Article({id:name})
    view = new Show({el: "#article", model: article})
    article.fetch()   
    
  edit: (name) ->
    article = new Article({id:name})
    view = new Editor({el: "#article", model: article})
    article.fetch()       
    
  markdownToHTML: (markdown) ->
    @converter ?= new Markdown.Converter()
    @converter.makeHtml(markdown)     

Bradbury.alert = (style,message) ->
  $("#alerts").append("<div class='fade in alert alert-#{style}'>#{message}</div>")
                    
$(document).ready ->
  window.Bradbury = new Bradbury()
  Backbone.history.start()
