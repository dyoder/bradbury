Express = require "express"
app = Express.createServer()
FS = require 'fs'

app.configure ->
  app.use Express.static("#{__dirname}/../web/")
  
  
app.put '/content/:name', (request,response) ->
  stream = FS.createWriteStream("#{__dirname}/../web/content/#{request.params.name}")
  request.pipe(stream)
  request.on 'end', ->
    response.writeHead(200)
    response.end()

app.listen '8888'