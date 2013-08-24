class dovecot {
  package { 'dovecot-imapd': 
    ensure => installed,
    alias  => 'dovecot',
  }
  
  exec { 'dovecot':
    command => 'echo "dovecot packages are installed"',
    path        => '/usr/sbin:/bin:/usr/bin:/sbin',
    logoutput   => true,
    refreshonly => true,
  }

  service { 'dovecot':
    ensure  => running,
    require => Exec['dovecot'],
  }
}
