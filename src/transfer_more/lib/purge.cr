# coding: utf-8

module TransferMore
  def self.purge(duration, verbose = true)
    t_from = Time.local - duration
    puts "[PURGE]  Start (#{t_from})" if verbose
    Dir.entries(storage "files").select do |dir|
      t_current = Time.parse(dir, TransferMore::TIME_FORMAT, location: Time::Location.load_local) rescue next
      r = t_current < t_from
    end.each do |dir|
      spawn do
        purge_dir(dir, verbose)
      end
    end
  end

  def self.purge_dir(dir, verbose = true)
    puts "[CLEAR]  " + storage("files#{dir}") + "..." if verbose
    Dir.glob(storage "files/#{dir}/*").each do |subdir|
      puts "[CLEAR]  #{subdir} ..." if verbose
      Dir.entries(subdir).each do |file|
        next if file == "." || file == ".."
        puts "[REMOVE] #{subdir}/#{file}" if verbose
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
      TransferMore.purge(TransferMore::STORAGE_DAYS.days)
    rescue err
      STDERR.puts "Purge: #{err}"
    end
    sleep(60)
  end
end
