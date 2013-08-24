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
  package {'dovecot-sieve':
      ensure  => installed,
      before  => Exec['dovecot'],
      require => Package['dovecot'],
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
