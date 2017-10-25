require "secure_random"

def get_upload_infos(filename : String)
  file_name = filename.downcase
  dir = Time.now.to_s(TransferMore::TIME_FORMAT) + "/" + SecureRandom.hex(TransferMore::SECURE_SIZE)
  Dir.mkdir_p(TransferMore.storage "files/#{dir}")
  visible_path = "#{dir}/#{file_name}"
  file_path = TransferMore.storage "files/#{visible_path}"
  {file_name, dir, visible_path, file_path}
end

# # TODO: handle multi upload

# Fast
put "/:file_name" do |env|
  file_name, dir, visible_path, file_path = get_upload_infos env.params.url["file_name"]
  File.open(file_path, "w") { |f| IO.copy(env.request.body.as(IO), f) }
  TransferMore::BASE_URL + "/" + visible_path + "\n"
end

# Slow
post "/:file_name" do |env|
  _, http_file_infos = env.params.files.first
  file_name, dir, visible_path, file_path = get_upload_infos env.params.url["file_name"]
  File.open(file_path, "w") { |f| IO.copy(http_file_infos.tmpfile, f) }
  TransferMore::BASE_URL + "/" + visible_path + "\n"
end

# Web upload
post "/" do |env|
  _, http_file_infos = env.params.files.first
  file_name, dir, visible_path, file_path = get_upload_infos http_file_infos.filename.to_s
  File.open(file_path, "w") { |f| IO.copy(http_file_infos.tmpfile, f) }
  env.redirect TransferMore::BASE_URL + "/" + visible_path
end

get "/:part1/:part2/:file_name" do |env|
  file_name = env.params.url["file_name"].downcase
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
