# 10-auth.conf
# dovecot-sql.conf.ext
class dovecot::postgres (
  $dbname          = 'mails',
  $dbpassword      = 'admin',
  $dbusername      = 'pass',
  $dbhost          = 'localhost',
  $dbport          = 5432,
  $mailstorepath   = '/srv/vmail/',
  $sqlconftemplate = 'dovecot/dovecot-sql.conf.ext',
) {
  file { "/etc/dovecot/dovecot-sql.conf.ext":
    ensure  => present,
    content => template($sqlconftemplate),
    mode    => '0600',
    owner   => root,
    group   => dovecot,
    require => Package['dovecot-pgsql'],
    before  => Exec['dovecot'],
    notify  => Service['dovecot'],
  }

  package {'dovecot-pgsql':
    ensure => installed,
    before => Exec['dovecot'],
    notify => Service['dovecot']
  }

  dovecot::config::dovecotcfmulti { 'sqlauth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "set include 'auth-sql.conf.ext'",
      "rm  include[ . = 'auth-system.conf.ext']",
    ],
    require     => File["/etc/dovecot/dovecot-sql.conf.ext"]
  }
}
