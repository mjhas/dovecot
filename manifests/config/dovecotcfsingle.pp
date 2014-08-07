define dovecot::config::dovecotcfsingle(
  $ensure = present,
  $config_file='dovecot.conf',
  $value=undef,
) {
  if ($::dovecot::master_config_file != undef and !empty($::dovecot::master_config_file)){
    $inner_config_file=$::dovecot::master_config_file
  } else {
    $inner_config_file=$config_file
  }
  require dovecot::config::augeas
  Augeas {
    context => "/files/etc/dovecot/${inner_config_file}",
    notify  => Service['dovecot'],
    require => Exec['dovecot'],
  }

  case $ensure {
    present: {
      if !$value {
        fail("dovecot /etc/dovecot/${inner_config_file} ${name} value not set")
      }
      augeas { "dovecot /etc/dovecot/${inner_config_file} ${name}":
        changes => "set ${name} '${value}'",
      }
    }

    absent: {
      augeas { "dovecot /etc/dovecot/${inner_config_file} ${name}":
        changes => "rm ${name}",
      }
    }
    default : {
      notice('unknown ensure value use absent or present')
    }
  }
}

