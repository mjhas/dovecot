# 90-plugin.conf *or*
# 90-sieve.conf
class dovecot::sieve (
  $username  = 'vmail',
  $groupname = 'vmail',
  ) {
  include dovecot

  file { '/var/lib/dovecot/sieve':
    ensure  => directory,
    owner   => $username,
    group   => $groupname,
    mode    => '0755',
    require => Package['dovecot-sieve'],
  }

  case ${::osfamily} {
    'Debian': {
      $package_name = 'dovecot-sieve'
      $mailpackages = ['dovecot-imapd', 'dovecot-pop3d']
    }
    'Redhat': {
      $package_name = 'dovecot-pigeonhole'
      $mailpackages = ['dovecot']
    }
    default:  { fail('Operating System not supported')}
  }


  package { $package_name :
      ensure  => installed,
      before  => Exec['dovecot'],
      require => Package[$mailpackages],
      alias   => 'dovecot-sieve',
  }

  dovecot::config::dovecotcfmulti { 'plugin':
    config_file => 'conf.d/90-plugin.conf',
    changes     => [
      "set plugin/sieve '~/.dovecot.sieve'",
      "set plugin/sieve_dir '~/sieve'",
      "set plugin/sieve_global_path '/var/lib/dovecot/sieve/default.sieve'",
      "set plugin/sieve_global_dir '/var/lib/dovecot/sieve/'",
      ],
  }
}
