define dovecot::config::dovecotcfmulti(
  $config_file='dovecot.conf',
  $changes=undef,
  $onlyif=undef,
) {
  include dovecot::config::augeas
  Augeas {
    context => "/files/etc/dovecot/${config_file}",
    notify  => Service['dovecot'],
  }

  augeas { "dovecot /etc/dovecot/${config_file} ${name}":
    changes => $changes,
    onlyif  => $onlyif,
  }
}

