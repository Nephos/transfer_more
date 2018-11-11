require "kemal"
require "./transfer_more/*"

static_headers do |response, filepath, filestat|
  if filepath =~ /\.html$/
    response.headers.add("Access-Control-Allow-Origin", "*")
  end
  response.headers.add("Content-Size", filestat.size.to_s)
end
serve_static true

# TODO: proper directory check
Dir.mkdir(TransferMore.storage("files")) rescue nil
Kemal.run
