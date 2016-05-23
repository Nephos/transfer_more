module TransferMore

  class MimeSearch
    @file     : String
    @extname  : String
    getter file, extname
    def initialize(@file)
      @extname = File.extname(file).delete(".")
    end

    EXT_TRANSFORM = {
      %w(jpg jpe) => "jpeg",
      %w(txt) => "plain",
    }

    EXT = {
      "image" => %w(png jpeg gif tiff),
      "text" => %(css html csv plain),
      "application" => %w(javascript json pdf xml zip),
      "audio" => %w(mpeg ogg),
      "video" => %w(mpeg mp4 webm),
    }

    MAGIC_NUMBERS = {
      [0xFF, 0xD8] => "image/jpg",
      [0x47, 0x49, 0x46, 0x38, 0x39, 0x61] => "image/gif",
      [0x47, 0x49, 0x46, 0x38, 0x37, 0x61] => "image/gif",
      [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] => "image/png",
      [0x23, 0x21] => "text/plain",
      [0x25, 0x50, 0x44, 0x46] => "application/pdf",
      [0xFF, 0xFB] => "audio/mpeg",
      [0x49, 0x44, 0x33] => "audio/mpeg",
      [0x4F, 0x67, 0x67, 0x53] => "audio/ogg",
      [0x1A, 0x45, 0xDF, 0xA3] => "video/x-matroska",
      [0x52, 0x49, 0x46, 0x46] => "video/avi", # wow avi and wav have the same shit
    }

    def get_content_type(default = "application/bin") : String
      mime = get_mime_from_magic_number || get_mime_from_extname
      mime = "#{mime}; charset=utf-8" if mime == "text/plain"
      mime || default
    end

    def get_mime_from_extname : String?
      return nil if extname.empty?
      replaced = EXT_TRANSFORM.select{|k,v| k.includes? extname}.first[1] rescue nil
      ext_usable = replaced || extname
      mime = EXT.select{|k,v| v.includes? ext_usable}.first rescue nil
      mime && "#{mime[0]}/#{ext_usable}"
    end

    def get_mime_from_magic_number : String?
      magic_number = Slice(UInt8).new(8)
      read = File.open(file).read(magic_number)
      magic_number = magic_number.to_a
      mime = MAGIC_NUMBERS.select{|k,v|
        length_to_compare = [read, k.size].min
        magic_number[0, length_to_compare] == k
      }
      mime.first[1] rescue nil
    end
  end

end
