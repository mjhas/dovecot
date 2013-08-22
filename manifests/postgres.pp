class dovecot::postgres (
  $dbname,
  $dbpassword,
  $dbusername,
  $dbhost='localhost',
  $mailstorepath='/srv/vmail/'
) {
  file { "/etc/dovecot/dovecot-sql.conf.ext":
    content => template('dovecot/dovecot-sql.conf.ext'),
    ensure  => present,
    mode    => 600,
    owner   => root,
    group   => dovecot,
    require => Package['dovecot-pgsql'],
  }
  
  package {'dovecot-pgsql':
    ensure => installed,
    notify => Class['dovecot']
  }

  dovecot::config::dovecotcfmulti { 'sqlauth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "set include 'auth-sql.conf.ext'",
      "rm  include[ . = 'auth-system.conf.ext']",
    ],
    require => File["/etc/dovecot/dovecot-sql.conf.ext"]
  }
}