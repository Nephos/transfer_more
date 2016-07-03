module TransferMore
  def self.purge(duration)
    tFrom = (Time.now - duration).epoch
    puts "[PURGE]  Start (#{tFrom})"
    Dir.entries(storage "files").select do |dir|
      tCurrent = Time.parse("#{dir}00", TransferMore::TIME_FORMAT).epoch rescue next
      r = tCurrent < tFrom
    end.each do |dir|
      spawn do
        purge_dir(dir)
      end
    end
  end

  def self.purge_dir(dir)
    puts "[CLEAR]  " + storage("files#{dir}") + "..."
    Dir.glob(storage "files/#{dir}/*").each do |subdir|
      puts "[CLEAR]  #{subdir} ..."
      Dir.entries(subdir).each do |file|
        next if file == "." || file == ".."
        puts "[REMOVE] #{subdir}/#{file}"
        File.delete("#{subdir}/#{file}")
      end
      Dir.rmdir(subdir)
    end
    Dir.rmdir(storage "files/#{dir}")
  end
end

spawn do
  loop do
    begin
      TransferMore.purge(60.seconds)
    rescue err
      STDERR.puts "Purge: #{err}"
    end
    sleep(60)
  end
end
