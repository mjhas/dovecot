# Note that you will still need to generate your passwd file.
class dovecot::passwdfile (
  $authscheme = "CRYPT",
  $username_format = "%u",
  $passwdfilename = "/etc/dovecot/dovecot-passdb"
) {
  file { "/etc/dovecot/conf.d/auth-passwdfile.conf.ext":
    ensure  => file,
    content => template('dovecot/auth-passwdfile.conf.ext'),
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
    require     => File["/etc/dovecot/conf.d/auth-passwdfile.conf.ext"]
  }
}
