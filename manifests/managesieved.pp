# 20-managesieve.conf
class dovecot::managesieved {
  include dovecot

  case ${::osfamily} {
    'Debian': { $package_name = 'dovecot-managesieved' }
    'Redhat': { $package_name = 'dovecot-managesieved' }
    default:  { fail('Operating System not supported')}
  }

  package { $package_name :
    ensure  => installed,
    before  => Exec['dovecot'],
    require => Package['dovecot'],
    alias   => 'dovecot-managesieved',
  }

  dovecot::config::dovecotcfmulti { 'managesieved-plugin':
    config_file => 'conf.d/20-managesieve.conf',
    changes     => [
      "set service[1] 'managesieve'",
      "set service[2] 'managesieve-login'",
      ],
  }
}
