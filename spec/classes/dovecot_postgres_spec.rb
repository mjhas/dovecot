require 'spec_helper'

describe 'dovecot::postgres', :type => :class do
  let(:facts) { {:operatingsystem => 'Debian', :operatingsystemrelease => '7.1'} }
  let(:params) { {:dbname=>'name', :dbpassword=>'password', :dbusername =>'username' } }
  it { should contain_package('dovecot-pgsql') }
  it do
      should contain_file('/etc/dovecot/dovecot-sql.conf.ext') \
        .with_content(/^connect = host=localhost port=5432 dbname=name user=username password=password$/)
    end
end

