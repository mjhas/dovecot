#require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet'
require 'rspec-puppet-augeas'

RSpec.configure do |c|
   puts 'module_path:'+c.module_path
   puts 'manifest_dir:'+c.manifest_dir
   c.augeas_fixtures = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'augeas')
   puts 'augeas_fixtures:'+c.augeas_fixtures
end
