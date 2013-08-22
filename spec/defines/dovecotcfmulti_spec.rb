require 'spec_helper'

describe 'dovecot::config::dovecotcfmulti', :type => :define do
  let(:facts) { {:operatingsystem => 'Debian', :operatingsystemrelease => '7.1'} }
  let(:title) { 'multi' }
  let(:params) { {:changes => [ 'set foo \'bar\'', 'rm bar' ], } }
  it 'should have an augeas resource' do
	should contain_augeas('dovecot /etc/dovecot/dovecot.conf multi')
  end
  describe_augeas 'dovecot /etc/dovecot/dovecot.conf multi', :lens => 'dovecot', :target => '/etc/dovecot/dovecot.conf' do
    it 'foo should exist with value foo and bar should not exist' do
      should execute.with_change

      aug_get('foo').should == 'bar' 
      aug_get('bar').should == nil

      should execute.idempotently
    end
  end
end
