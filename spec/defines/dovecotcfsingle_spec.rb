require 'spec_helper'

describe 'dovecot::config::dovecotcfsingle', :type => :define do
  let(:facts) { {:operatingsystem => 'Debian', :operatingsystemrelease => '7.1'} }
  let(:title) { 'foo' }
  let(:params) { {:ensure => 'present', :value => 'foo' } }
  it 'should have an augeas resource' do
	should contain_augeas('dovecot /etc/dovecot/dovecot.conf foo')
  end
  describe_augeas 'dovecot /etc/dovecot/dovecot.conf foo', :lens => 'dovecot', :target => '/etc/dovecot/dovecot.conf' do
    it 'foo should exist with value foo' do
      should execute.with_change

      aug_get('foo').should == 'foo' 

      should execute.idempotently
    end
  end
end

describe 'dovecot::config::dovecotcfsingle', :type => :define do
  let(:facts) { {:operatingsystem => 'Debian', :operatingsystemrelease => '7.1'} }
  let(:title) { 'bar' }
  let(:params) { {:ensure => 'absent'} }
  it 'should have an augeas resource' do
	should contain_augeas('dovecot /etc/dovecot/dovecot.conf bar')
  end
  describe_augeas 'dovecot /etc/dovecot/dovecot.conf bar', :lens => 'dovecot', :target => '/etc/dovecot/dovecot.conf' do
    it 'bar should not exist with value foo' do
      should execute.with_change

      aug_get('bar').should == nil

      should execute.idempotently
    end
  end
end

