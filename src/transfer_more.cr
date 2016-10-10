require "kemal"
require "./transfer_more/*"

Dir.mkdir(TransferMore.storage("files")) rescue nil
Kemal.run
