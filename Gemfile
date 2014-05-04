source 'https://rubygems.org'

group :development, :test do
  gem 'rake'
  gem 'facter', '~> 1.6.10'
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rspec-system-puppet', '~>2.0'
  gem 'puppet-lint', '~> 0.3.2'
  gem 'rspec-puppet-augeas', '~> 0.3.0'
  gem 'ruby-augeas', '~> 0.5.0'
  gem 'rspec-puppet', '~> 0.1.6'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
