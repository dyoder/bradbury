Article = Backbone.Model.extend 

  # url: -> "http://content-rocket-ly.commondatastorage.googleapis.com/#{@id}.json"
  url: "/content/hello-world.json"

Articles = Backbone.Collection.extend
  model: Article
  
  get: (name) ->
    if article = @_get(name)
      Bradbury.nextTick -> article.trigger("ready")
    else
      article = @load(name)
    article
    
  load: (name) ->
    article = new Article({id: name})
    article.fetch
      success: -> article.trigger("ready")
    @push(article)
    article

  _get: (name) ->
    Backbone.Collection.prototype.get.call(this,name)

Reader = Backbone.View.extend

  initialize: ->
    @template = _.template($("##{@$el.attr('id')}-template").html())
    
  attach: (model) ->
    @model.detach() if @model
    @model = model
    @model.on "ready", @render, this

  detach: ->
    if @model
      @model.off null, null, this
      @model = null

  render: ->
    console.log "Rendering reader view"
    article = @model.toJSON()
    document.title = article.title
    $(@el).html(@template(article))
    return @
  
  edit: -> window.open("documents/:name/editor")

Editor = Backbone.View.extend

  initialize: ->
    @template = _.template($("##{@$el.attr('id')}-editor-template").html())

  attach: (model) ->
    @model.detach() if @model
    @model = model
    @model.on "ready", @render, this
  
  detach: ->
    if @model
      @model.off null, null, this
      @model = null
    
  render: ->
    article = @model.toJSON()
    document.title = article.title
    $(@el).html(@template(article))
    $("#textarea-body, #input-title").change => @save()
    return @

  save: -> 
    @model.save @gather(),
      success: ->
        Bradbury.alert("success","Article saved.")
        
      error: -> 
        Bradbury.alert("error","Unable to save your changes.")
    
  gather: ->
    title: @$("#input-title").val()
    body: @$("#textarea-body").val()

Bradbury = Backbone.Router.extend

  routes:
      "documents/:name": "show"
      "documents/:name/editor": "edit"

  initialize: ->
    @articles = new Articles()
    @reader = new Reader({el: "#article"})
    @editor = new Editor({el: "#article"})
    
  show: (name) ->
    @editor.detach()
    @reader.attach(@articles.get(name))
    
  edit: (name) ->
    @reader.detach()
    @editor.attach(@articles.get(name))
    
  markdownToHTML: (markdown) ->
    @converter ?= new Markdown.Converter()
    @converter.makeHtml(markdown)     

Bradbury.alert = (style,message) ->
  # TODO: Figure out how to prevent this from eating the click event
  # Even show() on an existing alert has this problem.
  # $("#alerts").html("<div class='fade in alert alert-#{style}'>#{message}<a class='close' href='#'>&times;</a></div>")
  # $("#alerts .close").click -> $("#alerts").html(""); false

Bradbury.nextTick = (fn) ->
  setTimeout fn, 0
                    
$(document).ready ->
  window.Bradbury = new Bradbury()
  Backbone.history.start()
