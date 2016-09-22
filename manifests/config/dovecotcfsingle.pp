# one single dovecot config file change
define dovecot::config::dovecotcfsingle(
  $ensure      = present,
  $config_file = 'dovecot.conf',
  $option      = $name,
  $value       = undef,
) {
  Augeas {
    context => "/files/etc/dovecot/${config_file}",
    notify  => Service['dovecot'],
    require => Exec['dovecot'],
  }

  case $ensure {
    present: {
      if !$value {
        fail("dovecot /etc/dovecot/${config_file} ${option} value not set")
      }
      augeas { "dovecot /etc/dovecot/${config_file} ${option}":
        changes => "set ${option} '${value}'",
      }
    }

    absent: {
      augeas { "dovecot /etc/dovecot/${config_file} ${option}":
        changes => "rm ${option}",
      }
    }
    default : {
      notice('unknown ensure value use absent or present')
    }
  }
}
