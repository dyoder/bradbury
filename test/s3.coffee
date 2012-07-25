# TODO: Convert this into a set of real tests so we can do the port to pure JS

# First, generate a random key to use as a path
# Next, do a GET to verify that there is no content there
# PUT the content and GET it again to verify that it's now there
# DELETE the content and GET it again to verify that is no longer there

s3 = new S3
  awsAccessKey: "AKIAJVAOTCAX6CIY3UHQ"
  awsSecretAccessKey: "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"
  bucket: "content.rocket.ly"

content = 
  body: "Mary had a little lamb whose fleece was white as snow."
  type: "text/plain"
  
# s3.put "/content/text.txt", content, [],
#   success: (response) -> console.log response.status
#   error: (response) -> console.log response.status + "\n" + response.content.body
#   request_error: (error) -> console.log error

s3.get "/content/text.txt", [],
  success: (response) -> console.log response.status, response.content.body
  error: (response) -> console.log response.status + "\n" + response.content.body
  request_error: (error) -> console.log error


# s3.delete "/content/text.txt", [],
#   success: (response) -> console.log response.status, response.content.body
#   error: (response) -> console.log response.status
#   request_error: (error) -> console.log error
