# dovecot class
class dovecot(
  $package_configfiles  = 'keep'
) {

  $mailpackages = $::osfamily ? {
    default  => ['dovecot-imapd', 'dovecot-pop3d'],
    'Debian' => ['dovecot-imapd', 'dovecot-pop3d'],
    'Redhat' => ['dovecot',]
  }

  $needs_dovecot_lens = $::osfamily != 'Debian' or $::lsbmajdistrelease < 8

  ensure_packages([$mailpackages], { 'configfiles' => $package_configfiles })

  exec { 'dovecot':
    command     => 'echo "dovecot packages are installed"',
    path        => '/usr/sbin:/bin:/usr/bin:/sbin',
    logoutput   => true,
    refreshonly => true,
    require     => Package[$mailpackages],
  }

  service { 'dovecot':
    ensure  => running,
    require => Exec['dovecot'],
    enable  => true
  }
}
