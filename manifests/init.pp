class dovecot {

  $imap_package_name = $::osfamily ? {
    'Debian' => 'dovecot-imapd',
    'Redhat' => 'dovecot-imapd',
    default  => 'dovecot-imapd',
  }

  package { $imap_package_name:
    ensure => installed,
    alias  => 'dovecot',
    before => Exec['dovecot']
  }

  $pop3_package_name = $::osfamily ? {
    'Debian' => 'dovecot-pop3d',
    'Redhat' => 'dovecot',
    default  => 'dovecot-pop3d',
  }

  package { $pop3_package_name:
    ensure => installed,
    alias  => 'dovecot-pop3d',
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
