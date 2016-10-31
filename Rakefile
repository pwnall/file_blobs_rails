# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'file_blobs_rails'
  gem.homepage = 'https://github.com/pwnall/file_blobs_rails'
  gem.license = 'MIT'
  gem.summary = %Q{Database-backed file storage for Rails 5 applications.}
  gem.description = %Q{This gem is a quick way to add database-backed file storage to a Rails application. Files are stored in a dedicated table and de-duplicated.}
  gem.email = 'victor@costan.us'
  gem.authors = ['Victor Costan']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new
