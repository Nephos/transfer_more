require "kemal"
require "./transfer_more/*"

# static_headers do |response, filepath, filestat|
#   response.headers.add("Access-Control-Allow-Origin", "*")
#   response.headers.add("Content-Size", filestat.size.to_s)
# end
# serve_static true

# TODO: proper directory check
Dir.mkdir(TransferMore.storage("files")) rescue nil
Kemal.run
