require "secure_random"

put "/:file_name" do |env|
  file_name = env.params.url["file_name"].downcase
  dir = Time.now.to_s(TransferMore::TIME_FORMAT) + "/" + SecureRandom.hex(4)

  Dir.mkdir_p("/tmp/files/#{dir}")

  visible_path = "#{dir}/#{file_name}"
  file_path = "/tmp/files/#{visible_path}"

  File.write(file_path, env.request.body)
  ENV["TRANSFER_BASE_URL"] + "/" + visible_path + "\n"
end

get "/:part1/:part2/:file_name" do |env|
  file_name = env.params.url["file_name"].downcase
  path = "/tmp/files/" + env.params.url["part1"] + "/" + env.params.url["part2"] + "/" + file_name
  content_type = TransferMore::MimeSearch.new(path).get_content_type
  env.response.content_type = content_type
  File.read(path)
end

get "/" do |env|
  render "src/views/index.ecr"
end