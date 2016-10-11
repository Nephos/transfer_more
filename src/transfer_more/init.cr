module TransferMore
  BASE_URL     = ENV["TRANSFER_BASE_URL"] rescue (STDERR.puts "warning: no TRANSFER_BASE_URL set"; "http://localhost:3000")
  BASE_STORAGE = ENV["TRANSFER_BASE_STORAGE"]? || "/tmp"
end

require "./lib/*"
