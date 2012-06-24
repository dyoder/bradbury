Express = require "express"
app = Express.createServer()
FS = require 'fs'

app.configure ->
  app.use Express.logger()
  app.use Express.static("#{__dirname}/../web/")
  
  
app.put '/content/:name', (request,response) ->
  stream = FS.createWriteStream("#{__dirname}/../web/content/#{request.params.name}")
  stream.on "error", (error) ->
    console.log(error)
  request.on 'error', (error) ->
    console.log(error)
  request.on 'end', ->
    response.writeHead(200)
    response.end()
  request.pipe(stream)


app.listen '8888'