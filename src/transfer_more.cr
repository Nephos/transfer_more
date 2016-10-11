require "kemal"
require "./transfer_more/*"

# TODO: proper directory check
Dir.mkdir(TransferMore.storage("files")) rescue nil
Kemal.run
