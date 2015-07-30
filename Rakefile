require "rubygems"
require 'geminabox/rake'
require "rspec/core/rake_task"

Geminabox::Rake.install :dir => './', :host => 'http://gems.spokeo.com'

task :default => :spec

desc "Run all specification examples"
RSpec::Core::RakeTask.new do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "full-name-splitter"
    gemspec.summary = "FullNameSplitter splits full name into first and last name considering name prefixes and initials"
    gemspec.description = ""
    gemspec.email = "pahanix@gmail.com"
    gemspec.homepage = "http://github.com/pahanix/full-name-splitter"
    gemspec.authors = ["Pavel Gorbokon", "contributors Michael S. Klishin and Trevor Creech"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end