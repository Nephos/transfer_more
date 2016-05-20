module TransferMore

  def self.purge(duration)
    tFrom = (Time.now - duration).epoch
    puts "[PURGE]  Start (#{tFrom})"
    Dir.entries("/tmp/files").select do |dir|
      tCurrent = Time.parse("#{dir}00", TransferMore::TIME_FORMAT).epoch rescue next
      r = tCurrent < tFrom
    end.each do |dir|
      spawn do
        purge_dir(dir)
      end
    end
  end

  def self.purge_dir(dir)
    puts "[CLEAR]  /tmp/files/#{dir} ..."
    Dir.glob("/tmp/files/#{dir}/*").each do |subdir|
      puts "[CLEAR]  #{subdir} ..."
      Dir.entries(subdir).each do |file|
        next if file == "." || file == ".."
        puts "[REMOVE] #{subdir}/#{file}"
        File.delete("#{subdir}/#{file}")
      end
      Dir.rmdir(subdir)
    end
    Dir.rmdir("/tmp/files/#{dir}")
  end

end

spawn do
  loop do
    TransferMore.purge(7.days)
    sleep(60)
  end
end
