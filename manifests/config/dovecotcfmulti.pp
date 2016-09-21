# multiple dovecot config file changes at once
define dovecot::config::dovecotcfmulti(
  $config_file='dovecot.conf',
  $changes=undef,
  $onlyif=undef,
) {
  Augeas {
    context => "/files/etc/dovecot/${config_file}",
    notify  => Service['dovecot'],
    require => Exec['dovecot'],
  }

  augeas { "dovecot /etc/dovecot/${config_file} ${name}":
    changes => $changes,
    onlyif  => $onlyif,
  }
}
