# == Class: dovecot::config::augeas
#
# Update some Augeas lenses, when a really old Augeas release (< 1.0.0) is installed.
#
# NOTE: we should consider removing this in the future, since most # distros are on Augeas > 1 now, and even PuppetLabs
# ships those packages.
#
class dovecot::config::augeas {
  if (versioncmp($::augeasversion, '1.0.0') < 0) {
    File {
      ensure => file,
      owner  => root,
      group  => root,
      mode   => '0644'
    }
    file { '/usr/share/augeas/lenses/dist/dovecot.aug':
      source => 'puppet:///modules/dovecot/dovecot.aug',
    }

    file { '/usr/share/augeas/lenses/dist/build.aug':
      source => 'puppet:///modules/dovecot/build.aug',
    }

    file { '/usr/share/augeas/lenses/dist/util.aug':
      source => 'puppet:///modules/dovecot/util.aug',
    }

  }
}
