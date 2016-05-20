require "secure_random"

EXT_TRANSFORM = {
  %w(jpg jpe) => "jpeg",
}

EXT = {
  "image" => %w(png jpeg gif tiff),
  "text" => %(css text html csv),
  "application" => %w(javascript json ogg pdf xml zip),
  #"audio" => %w(mpeg),
  "video" => %w(mpeg mp4 webm),
}

MAGIC_NUMBERS = {
  [0xFF, 0xD8] => "image/jpg",
  [0x47, 0x49, 0x46, 0x38, 0x39, 0x61] => "image/gif",
  [0x47, 0x49, 0x46, 0x38, 0x37, 0x61] => "image/gif",
  [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] => "image/jpg",
  [0x23, 0x21] => "text/text",
  [0x25, 0x50, 0x44, 0x46] => "application/pdf",
}
def get_content_type(file : String) : String
  get_mime_from_magic_number(file) ||
  get_mime_from_extname(File.extname(file)) ||
  "application/bin"
end

def get_mime_from_extname(extname : String) : String?
  return nil if extname.empty?
  replaced = EXT_TRANSFORM.select{|k,v| k.includes? extname}.first[1] rescue nil
  extname = replaced if replaced
  mime = EXT.select{|k,v| v.includes? extname}.first rescue nil
  mime && "#{mime[0]}/#{mime[1]}"
end

def get_mime_from_magic_number(file : String) : String?
  magic_number = Slice(UInt8).new(8)
  read = File.open(file).read(magic_number)
  magic_number = magic_number.to_a
  mime = MAGIC_NUMBERS.select{|k,v|
    length_to_compare = [read, k.size].min
    magic_number[0, length_to_compare] == k
  }
  mime.first[1] rescue nil
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
  path = "/tmp/files/" + env.params.url["part1"] + "/" + env.params.url["part2"] + "/" + file_name
  content_type = get_content_type(path)
  env.response.content_type = content_type
  File.read(path)
end

get "/" do |env|
  render "src/views/index.ecr"
end
