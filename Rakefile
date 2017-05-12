require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "reek/rake/task"
require "rubocop/rake_task"

Reek::Rake::Task.new
RSpec::Core::RakeTask.new
RuboCop::RakeTask.new

task default: %i[spec rubocop reek]
