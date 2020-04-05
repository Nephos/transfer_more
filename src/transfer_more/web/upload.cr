require "random/secure"

private def get_upload_infos(filename : String)
  file_name = filename.downcase
  dir = Time.local.to_s(TransferMore::TIME_FORMAT) + "/" + Random::Secure.hex(TransferMore::SECURE_SIZE) + (ENV["TRANSFER_MORE_CHRISTMAS"]? == "true" ? "/\u{1F384}" : "")
  Dir.mkdir_p TransferMore.storage("files/#{dir}")
  visible_path = "#{dir}/#{file_name}"
  file_path = TransferMore.storage("files/#{visible_path}")
  {file_name, dir, visible_path, file_path}
end

private def upload(env, name_of_upload, io_to_copy)
  begin
    file_name, dir, visible_path, file_path = get_upload_infos name_of_upload
    File.open(file_path, "w") { |f| IO.copy(io_to_copy, f) }
    TransferMore.base_url(env) + "/" + visible_path
  rescue err
    env.response.status_code = 500
    "Error 500: #{err}"
  end
end

private def errorNoFilenameprovided(env)
  env.response.status_code = 400
  return "Error 400: No filename provided"
end

private def parseAndUpload(env)
  file_url = ""
  filename = ""
  begin
    HTTP::FormData.parse(env.request) do |upload|
      case upload.name
      when "name"
        filename = upload.body.gets_to_end
      when "file"
        filename = upload.filename || filename
        # Be sure to check if file.filename is not empty otherwise it'll raise a compile time error
        raise "No filename" if !filename || filename.empty?
        file_url = upload(env, filename, upload.body)
      end
    end
  rescue err
    puts err
    body = env.request.body
    if !body
      env.response.status_code = 400
      return "Error 400: No body"
    end
    filename = env.params.url["filename"]?
    puts "'filename'", filename
    return errorNoFilenameprovided(env) if !filename || filename.empty?
    file_url = upload(env, filename, body)
  end

  if env.request.headers["User-Agent"]?.to_s.match(/^curl/)
    file_url
  else
    render "src/views/index.ecr"
  end
end

post "/:filename" do |env|
  parseAndUpload(env)
end

put "/:filename" do |env|
  parseAndUpload(env)
end

# Web upload
post "/" do |env|
  parseAndUpload(env)
end

get "/:part1/:part2/:file_name" do |env|
  file_name = env.params.url["file_name"].to_s.downcase
  path = TransferMore.storage("files") + "/" + env.params.url["part1"] + "/" + env.params.url["part2"] + "/" + file_name
  begin
    content_type = TransferMore::MimeSearch.new(path).get_content_type
    env.response.content_type = content_type
    File.read(path)
  rescue
    env.response.status_code = 404
  end
end

get "/" do |env|
  file_url = ""
  render "src/views/index.ecr"
end
