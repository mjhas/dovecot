require 'spec_helper'

describe 'dovecot::postgres', :type => :class do
  let(:params) { {
    :dbname     => 'name',
    :dbpassword => 'password',
    :dbusername => 'username'
  } }

  context 'On Debian' do
    let(:facts) { {
      :operatingsystem        => 'Debian',
      :osfamily               => 'Debian',
      :operatingsystemrelease => '7.1'
    } }
    it { should contain_package('dovecot-pgsql') }
    it do
        should contain_file('/etc/dovecot/dovecot-sql.conf.ext') \
          .with_content(/^connect = host=localhost port=5432 dbname=name user=username password=password$/)
      end
  end

  context 'On unknown OS' do
    let(:facts) { {
      :operatingsystem        => 'foo',
      :operatingsystemrelease => '1.0',
      :osfamily               => 'bar'
    }}
    it { should raise_error(/Operating System not supported/) }
  end
end
