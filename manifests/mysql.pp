# 10-auth.conf
# dovecot-sql.conf.ext
class dovecot::mysql (
  $dbname          = 'mails',
  $dbpassword      = 'admin',
  $dbusername      = 'pass',
  $dbhost          = 'localhost',
  $dbport          = 5432,
  $dbdriver        = 'mysql',
  $pass_scheme     = 'MD5-CRYPT',
  $sqlconftemplate = 'dovecot/dovecot-sql.conf.ext',
  $user_query      = "SELECT maildir, 5000 AS uid, 5000 AS gid FROM mailbox WHERE username  = '%u'",
  $pass_query      = "SELECT password FROM mailbox WHERE username = '%u'"
) {
  file { "/etc/dovecot/dovecot-sql.conf.ext":
    ensure  => present,
    content => template($sqlconftemplate),
    mode    => '0600',
    owner   => root,
    group   => dovecot,
    require => Package['dovecot-mysql'],
    before  => Exec['dovecot'],
    notify  => Service['dovecot'],
  }

  package {'dovecot-mysql':
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
