require "secure_random"

TRANSFORM = {
  "jpg" => "jpeg",
}
EXT = {
  "image" => %w(png jpeg gif tiff),
  "text" => %(css text html csv),
  "application" => %w(javascript json ogg pdf xml zip),
  #"audio" => %w(mpeg),
  "video" => %w(mpeg mp4 webm),
}
def get_content_type(extension : String) : String
  extension = TRANSFORM[extension]? || extension
  puts extension
  EXT.select{|k,v| v.includes? extension}.first[0] + "/#{extension}" rescue "application/bin"
end

put "/:file_name" do |env|
  file_name = env.params.url["file_name"]
  dir_part0 = "/tmp/files"
  dir_part1 = Time.now.to_s("%Y%m%d%H%M")
  dir_part2 = SecureRandom.hex(4)

  # TODO recursive -p and use basename on file_name
  Dir.mkdir(dir_part0) rescue puts("cannot make 0")
  Dir.mkdir(dir_part0 + "/" + dir_part1) rescue puts("cannot make 1")
  Dir.mkdir(dir_part0 + "/" + dir_part1 + "/" + dir_part2) rescue puts("cannot make 2")

  path = dir_part1 + "/" + dir_part2 + "/" + file_name
  file_path = dir_part0 + "/" + path

  File.write(file_path, env.request.body)
  ENV["TRANSFER_BASE_URL"] + "/" + path + "\n"
end

get "/:part1/:part2/:file_name" do |env|
  file_name = env.params.url["file_name"]
  content_type = get_content_type(extension: file_name.split(".").last)
  env.response.content_type = content_type
  File.read("/tmp/files/" + env.params.url["part1"] + "/" + env.params.url["part2"] + "/" + file_name)
end

get "/" do |env|
  File.read("index.html")
end
