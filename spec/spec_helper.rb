#require 'rubygems'
#require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet'
require 'rspec-puppet-augeas'

RSpec.configure do |c|
  c.module_path = File.expand_path(File.join(__FILE__, '../../../'))
  puts 'module_path:'+c.module_path
  c.manifest_dir = File.expand_path(File.join(__FILE__, '..', 'fixtures/manifests'))
  puts 'manifest_dir:'+c.manifest_dir
  c.augeas_fixtures = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'augeas')
end
