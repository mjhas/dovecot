define dovecot::config::dovecotcfmulti(
  $config_file='dovecot.conf',
  $changes=undef,
  $onlyif=undef,
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

  augeas { "dovecot /etc/dovecot/${inner_config_file} ${name}":
    changes => $changes,
    onlyif  => $onlyif,
  }
}

