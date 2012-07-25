Bradbury = Backbone.Router.extend

  routes:
      "documents/:name": "show"
      "documents/:name/editor": "edit"

  initialize: ->
    
  show: (name) ->
    
  edit: (name) ->
    
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
  
  editor = $("form.editor")
  $("a").click -> editor.show()
