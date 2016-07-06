module TransferMore
  def self.storage(f)
    File.expand_path f, BASE_STORAGE
  end
end
