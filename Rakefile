require 'rubygems'
require 'bundler/setup'

Bundler.require :default

require 'puppetlabs_spec_helper/rake_tasks'
require 'rspec-system/rake_task'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp"]

task :default do
          puts "\n\nTo run the Tests on Debian you need to install the augeas files!\n\n"
end
