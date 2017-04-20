require 'minitar'
require 'concurrent'
require 'benchmark'

tar_file   = ARGV[0]
output_dir = ARGV[1]

EXTRACT     = Concurrent::FixedThreadPool.new(300, max_queue: 0)
DIR_CREATE  = Concurrent::FixedThreadPool.new(150, max_queue: 0)

input       = Archive::Tar::Minitar::Input.new(File.open(tar_file))
errors      = []
files       = []
directories = []

input.each do |entry|
  if entry.directory?
    # TODO: Path protection
    directories << entry.full_name
  else
    files << [entry.full_name, entry.mode, entry.read]
  end
end

Benchmark.bm do |x|
  x.report("dirs: ") {
    directories.each do |dir|
      DIR_CREATE.post(dir) do |d|
        begin
          FileUtils.mkdir_p(File.join(output_dir, d))
        rescue Exception => e
          errors << e
        end
      end
    end

    DIR_CREATE.shutdown
    DIR_CREATE.wait_for_termination
  }

  x.report("files: ") {
    files.each do |file|
      EXTRACT.post(file) do |path, mode, content|
        begin
          path = File.join(output_dir, path)

          File.open(path, 'wb', mode) do |f|
            f.write(content)
          end
        rescue Exception => e
          errors << e
        end
      end
    end

    EXTRACT.shutdown
    EXTRACT.wait_for_termination
  }
end

if errors.first
  puts errors.first.message
  puts errors.first.backtrace.join("\n")
end
