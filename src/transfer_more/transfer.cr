require "secure_random"

TRANSFORM = {
  %w(jpg jpe) => "jpeg",
}
EXT = {
  "image" => %w(png jpeg gif tiff),
  "text" => %(css text html csv),
  "application" => %w(javascript json ogg pdf xml zip),
  #"audio" => %w(mpeg),
  "video" => %w(mpeg mp4 webm),
}
def get_content_type(extension : String) : String
  extension = TRANSFORM.select{|k,v| k.includes? extension}.first[1] rescue extension
  EXT.select{|k,v| v.includes? extension}.first[0] + "/#{extension}" rescue "application/bin"
end

put "/:file_name" do |env|
  file_name = env.params.url["file_name"].downcase
  dir_part0 = "/tmp/files"
  dir_part1 = Time.now.to_s(TransferMore::TIME_FORMAT)
  dir_part2 = SecureRandom.hex(4)

  Dir.mkdir_p(dir_part0 + "/" + dir_part1 + "/" + dir_part2)

  path = dir_part1 + "/" + dir_part2 + "/" + file_name
  file_path = dir_part0 + "/" + path

  File.write(file_path, env.request.body)
  ENV["TRANSFER_BASE_URL"] + "/" + path + "\n"
end

get "/:part1/:part2/:file_name" do |env|
  file_name = env.params.url["file_name"].downcase
  content_type = get_content_type(extension: file_name.split(".").last)
  env.response.content_type = content_type
  File.read("/tmp/files/" + env.params.url["part1"] + "/" + env.params.url["part2"] + "/" + file_name)
end

get "/" do |env|
  render "src/views/index.ecr"
end
