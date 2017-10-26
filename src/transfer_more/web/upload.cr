require "secure_random"

private def get_upload_infos(filename : String)
  file_name = filename.downcase
  dir = Time.now.to_s(TransferMore::TIME_FORMAT) + "/" + SecureRandom.hex(TransferMore::SECURE_SIZE)
  Dir.mkdir_p(TransferMore.storage "files/#{dir}")
  visible_path = "#{dir}/#{file_name}"
  file_path = TransferMore.storage "files/#{visible_path}"
  {file_name, dir, visible_path, file_path}
end

private def upload(env, name_of_upload, io_to_copy)
  file_name, dir, visible_path, file_path = get_upload_infos name_of_upload
  File.open(file_path, "w") { |f| IO.copy(io_to_copy, f) }
  TransferMore.base_url(env) + "/" + visible_path
end

# Fast
put "/:file_name" do |env|
  begin
    upload(env, env.params.url["file_name"], env.request.body.as(IO)) + "\n"
  rescue err
    env.response.status_code = 500
    "Error 500"
  end
end

# Slow
post "/:file_name" do |env|
  begin
    _, http_file_infos = env.params.files.first
    upload(env, env.params.url["file_name"], http_file_infos.tmpfile) + "\n"
  rescue err
    env.response.status_code = 500
    "Error 500"
  end
end

# Web upload
post "/" do |env|
  begin
    _, http_file_infos = env.params.files.first
    env.redirect upload(env, http_file_infos.filename.to_s, http_file_infos.tmpfile)
  rescue err
    env.response.status_code = 500
    "Error 500"
  end
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
  render "src/views/index.ecr"
end
