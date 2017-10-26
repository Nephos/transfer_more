module TransferMore
  SSL_ENABLED  = ENV["TRANSFER_SSL_ENABLED"]?.to_s.downcase == "true"
  BASE_STORAGE = ENV["TRANSFER_BASE_STORAGE"]? || "/tmp"
  SECURE_SIZE  = Int32.new(ENV["TRANSFER_SECURE_SIZE"]? || 4)
  STORAGE_DAYS = Int32.new(ENV["TRANSFER_STORAGE_DAYS"]? || 7)
end

require "./lib/*"
