class dovecot::passwdfile (
  $authscheme = "CRYPT"
  $username_format = "%u"
  $passwdfilename = "/etc/dovecot/dovecot-passdb"
) {
  file { "/etc/dovecot/dovecot-sql.conf.ext":
    ensure  => present,
    content => template('dovecot/dovecot-passwdfile.conf.ext'),
    mode    => '0600',
    owner   => root,
    before  => Exec['dovecot'],
  }

  dovecot::config::dovecotcfmulti { 'passwdfileauth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "set include 'auth-passwdfile.conf.ext'",
      "rm  include[ . = 'auth-system.conf.ext']",
    ],
    require => File["/etc/dovecot/dovecot-passwdfile.conf.ext"]
  }
}
