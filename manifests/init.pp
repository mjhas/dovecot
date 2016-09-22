# dovecot class
class dovecot(
  $packages             = undef,
  $package_configfiles  = 'keep'
) {

  $mailpackages = $::osfamily ? {
    default  => ['dovecot-core'],
    'Debian' => ['dovecot-core'],
    'Redhat' => ['dovecot',]
  }

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
    enable  => true,
  }
}
