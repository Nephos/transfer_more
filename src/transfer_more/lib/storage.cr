module TransferMore
  def self.storage(f)
    File.expand_path f, BASE_STORAGE
  end

  def self.base_url(env)
    "http#{Kemal.config.ssl ? 's' : nil}://#{(env.request.host_with_port || "localhost:3000")}"
  end
end
