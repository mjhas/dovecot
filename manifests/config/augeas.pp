# augeas lenses
class dovecot::config::augeas {
  if $::dovecot::needs_dovecot_lens {
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
