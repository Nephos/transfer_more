require "kemal"
require "./transfer_more/*"

Dir.mkdir(TransferMore.storage("files"))
Kemal.run
