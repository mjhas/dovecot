require 'spec_helper'

describe 'dovecot', :type => :class do
  let(:facts) { {:operatingsystem => 'Debian', :operatingsystemrelease => '7.1'} }
  it { should contain_package('dovecot-imapd') }
  it { should contain_service('dovecot') }
end

