module TransferMore
  def self.storage(f)
    File.expand_path f, BASE_STORAGE
  end

  def self.base_url(env)
    scheme = Kemal.config.ssl || SSL_ENABLED ? "https://" : "http://"
    host_port = env.request.headers["Host"]? || HOST_PORT
    "#{scheme}#{host_port}"
  end
end
