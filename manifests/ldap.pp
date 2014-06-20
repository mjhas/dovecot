class dovecot::ldap (
  $ldap_hosts = 'ldap.example.org:389',
  $ldap_dn = 'cn=vmail,cn=users,dc=example,dc=org',
  $ldap_dnpass = 'NotPassword#1234!',
  $ldap_auth_bind_userdn = 'cn=%u,cn=users,dc=example,dc=org',
  $ldap_base = 'cn=users,dc=example,dc=org',
  $ldap_auth_bind = 'no',
  $ldap_scope = 'subtree'
) {
  file { "/etc/dovecot/dovecot-ldap.conf.ext":
    ensure  => present,
    content => template('dovecot/dovecot-ldap.conf.ext'),
    mode    => '0600',
    owner   => root,
    group   => dovecot,
    before  => Exec['dovecot'],
  }

  dovecot::config::dovecotcfmulti { 'ldapauth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "set include 'auth-ldap.conf.ext'",
      "rm  include[ . = 'auth-system.conf.ext']",
    ],
    require => File["/etc/dovecot/dovecot-ldap.conf.ext"]
  }
}
