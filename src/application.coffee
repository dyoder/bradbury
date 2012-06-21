Bradbury = 
  Models: {}
  Controllers: {}
  Views: {}

Bradbury.Models.Document = Backbone.Model.extend 
  url: ->
    # base = 'documents'
    # if (this.isNew()) 
    #   return base;
    # return base + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.name;

console.log Backbone

Bradbury.Controllers.Documents = Backbone.Router.extend
  routes:
      "documents/:name": "show"

  show: (name) ->
    $("#name").text(name)
    
$(document).ready ->
  new Bradbury.Controllers.Documents()
  Backbone.history.start()
  console.log "bradbury started ..."