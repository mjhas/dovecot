class dovecot {

  $package_name = $::osfamily ? {
    'Debian' => 'dovecot-imapd',
    'Redhat' => 'dovecot',
    default  => 'dovecot-imapd',
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
