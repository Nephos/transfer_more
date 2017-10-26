module TransferMore
  def self.storage(f)
    File.expand_path f, BASE_STORAGE
  end

  def self.base_url(env)
    scheme =
    "http#{Kemal.config.ssl || SSL_ENABLED ? 's' : nil}://#{(env.request.host_with_port || "localhost:3000")}"
  end
end
