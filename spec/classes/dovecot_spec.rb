require 'spec_helper'

describe 'dovecot', :type => :class do
  context 'On Debian' do
    let(:facts) { {
      :operatingsystem        => 'Debian',
      :osfamily               => 'Debian',
      :operatingsystemrelease => '7.1'
    } }
    it { should contain_package('dovecot-imapd') }
    it { should contain_service('dovecot') }
  end

  context 'On unknown OS' do
    let(:facts) { {
      :operatingsystem        => 'foo',
      :operatingsystemrelease => '1.0',
      :osfamily               => 'bar'
    } }
    it { should raise_error(/Operating System not supported/) }
  end
end

