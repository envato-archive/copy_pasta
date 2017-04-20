require 'minitar'
require 'concurrent'

tar_file   = ARGV[0]
output_dir = ARGV[1]

EXTRACT    = Concurrent::FixedThreadPool.new(100, max_queue: 0)
input      = Archive::Tar::Minitar::Input.new(File.open(tar_file))
errors     = []
files      = []

input.each do |entry|
  if entry.directory?
    # Allow the lib to protect against path attacks
    input.extract_entry(output_dir, entry)
  else
    files << [entry.full_name, entry.mode, entry.read]
  end
end

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

if errors.first
  puts errors.first.message
  puts errors.first.backtrace.join("\n")
end

EXTRACT.shutdown
EXTRACT.wait_for_termination
