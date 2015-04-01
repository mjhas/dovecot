# dovecot class
class dovecot (
  $package_configfiles  = 'keep'
) {
  case ${::osfamily} {
    'Debian': { $mailpackages = ['dovecot-imapd', 'dovecot-pop3d'] }
    'Redhat': { $mailpackages = ['dovecot'] }
    default:  { fail('Operating System not supported')}
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
    enable  => true
  }
}
