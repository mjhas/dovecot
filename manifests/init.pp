# = Class: dovecot
#
# This base resources installs the dovecot package and starts the service
# == Parameters:
# 
# $master_config_file:: override the configuration file given for dovecot::config::dovecotcfmulti or dovecot::config::dovecotcfsingle
#    The filename should be relative to /etc/dovecot/ e.g. something like "conf.d/99-mail-stack-delivery.conf"
#
# == Actions:
#   - installs dovecot package
#   - starts dovecot service
class dovecot(
  $master_config_file = undef
) {

  case $::osfamily {
    'Debian': { $package_name = 'dovecot-imapd' }
    'Redhat': { $package_name = 'dovecot' }
     default: { $package_name = 'dovecot-imapd' }
  }  
  
  package { $package_name:
    ensure => installed,
    alias  => 'dovecot',
    before => Exec['dovecot']
  }

  exec { 'dovecot':
    command     => 'echo "dovecot packages are installed"',
    path        => '/usr/sbin:/bin:/usr/bin:/sbin',
    logoutput   => true,
    refreshonly => true,
  }

  service { 'dovecot':
    ensure  => running,
    require => Exec['dovecot'],
    enable  => true
  }
}
