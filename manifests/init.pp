class dovecot {
  package { 'dovecot-imapd': ensure => installed, }

  service { 'dovecot':
    ensure  => running,
    require => Package[dovecot-imapd],
  }
}
