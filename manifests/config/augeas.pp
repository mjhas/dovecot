class dovecot::config::augeas {

  case $::lsbdistcodename {
    /squeeze|squeeze-lts|wheezy/: {
      $install_lenses = true
    }
    /lucid|precise|trusty|utopic/: {
      $install_lenses = true
    }
    default: { $install_lenses = false }
  }

  if $install_lenses {
    file { '/usr/share/augeas/lenses/dist/dovecot.aug':
      ensure => present,
      source => 'puppet:///modules/dovecot/dovecot.aug',
      owner  => root,
      group  => root,
      mode   => '0644'
    }

    file { '/usr/share/augeas/lenses/dist/build.aug':
      ensure => present,
      source => 'puppet:///modules/dovecot/build.aug',
      owner  => root,
      group  => root,
      mode   => '0644'
    }

    file { '/usr/share/augeas/lenses/dist/util.aug':
      ensure => present,
      source => 'puppet:///modules/dovecot/util.aug',
      owner  => root,
      group  => root,
      mode   => '0644'
    }
  }
}
