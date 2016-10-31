require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'minitest'

require 'action_controller'
require 'active_record'
require 'active_support/core_ext'
require 'rails'

require 'mocha/setup'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'file_blobs_rails'

require 'helpers/action_controller.rb'
require 'helpers/db_setup.rb'
require 'helpers/fixtures.rb'
require 'helpers/i18n.rb'
require 'helpers/migrations.rb'
require 'helpers/rails.rb'
require 'helpers/routes.rb'
require 'helpers/test_order.rb'

class MiniTest::Test
end

require 'minitest/autorun'
