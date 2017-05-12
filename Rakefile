require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "reek/rake/task"


Reek::Rake::Task.new
RSpec::Core::RakeTask.new

task default: %i[spec reek]
