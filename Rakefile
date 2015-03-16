require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.verbose = true
# t.rspec_opts << ' more options'
#  t.rcov = true
end
Coveralls::RakeTask.new
default_task = [:spec]
default_task << 'coveralls:push' #if ENV['TRAVIS']
task default: default_task
