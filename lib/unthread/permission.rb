module Unthread
  # Public: Sets permissions for the given files and directories.
  class Permission
    def self.set(files, options = {})
      perms = new(files, options)
      perms.create_work
      perms.run
    end

    # Public: The thread manager for creating directories.
    attr_reader :executor

    # Public: The options given for file ownership.
    attr_reader :options

    def initialize(files, options = {})
      @files    = files
      @options  = options
      @executor = Unthread::Executor.new(options.fetch(:threads, 100))
    end

    # Public: Adds all files and directories to the queue for permission changes.
    def create_work
      @files.each do |file|
        executor.queue do
          chown(file)
          chmod(file)
        end
      end
    end

    # Public: Sets all permission
    #
    # Returun an array of files permission were set on
    def run
      executor.run
      @files
    end

    # Private: Change the ownership of the given file
    #
    # file - The string file name.
    def chown(file)
      user  = options[:user]
      group = options[:group]
      return unless user || group

      FileUtils.chown(user, group, file)
    end

    # Private: Change the permission of the given file
    #
    # file - The string file name.
    def chmod(file)
      mode = options[:mode]
      return unless mode

      FileUtils.chmod(mode, file)
    end
  end
end
