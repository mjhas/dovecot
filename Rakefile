require 'rubygems'
require 'bundler/setup'

Bundler.require :default

require 'puppetlabs_spec_helper/rake_tasks'
require 'rspec-system/rake_task'
require 'puppet-lint/tasks/puppet-lint'

task :default do
	  sh %{rake -T}
          puts "\n\nTo run the Tests on Debian you need to install the augeas files!"
end
