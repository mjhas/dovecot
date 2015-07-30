# dovecot-ldap.conf.ext
# auth-ldap.conf.ext
class dovecot::ldap (
  $ldap_hosts            = 'ldap.example.org:389',
  $ldap_uris             = false,
  $ldap_dn               = 'cn=vmail,cn=users,dc=example,dc=org',
  $ldap_dnpass           = 'NotPassword#1234!',
  $ldap_auth_bind_userdn = 'cn=%n,cn=users,dc=example,dc=org',
  $ldap_base             = 'cn=users,dc=example,dc=org',
  $ldap_auth_bind        = 'no',
  $ldap_scope            = 'subtree',
  $ldap_debug_level      = '-1',
  $ldap_userdb_static    = 'uid=vmail gid=vmail home=/srv/vmail/%n mail=maildir:~/mail',
  $ldap_user_filter      = '(&(objectClass=user)(cn=%n))',
  $ldap_user_attrs       = '=home=/srv/vmail/%d/%n, =uid=vmail, =gid=vmail, =mail=maildir:~/mail',
  $ldap_pass_filter      = '(&(objectClass=user)(cn=%n))',
  $ldap_pass_attrs       = 'cn=user', #cn is ldap attribute name, user is dovecot field
  $ldap_iterate_attrs    = 'cn=user',
  $ldap_iterate_filter   = '(objectClass=user)',
  $ldap_tls              = 'no',
  $ldap_tls_ca_cert_file = false,
  $ldap_tls_ca_cert_dir  = false,
  $ldap_tls_cipher_suite = false,
  $ldap_tls_cert_file    = false,
  $ldap_tls_key_file     = false,
  $ldap_tls_require_cert = 'demand',
  ) {

  if $ldap_uris and $ldap_hosts {
    fail('uris and hosts are mutually exclusives')
  }

  package {'dovecot-ldap':
    ensure => installed,
    before => Exec['dovecot'],
    notify => Service['dovecot']
  }

  # TODO the next two files use same template, probably should be creating symlink....
  file { '/etc/dovecot/dovecot-ldap.conf.ext':
    ensure  => present,
    content => template('dovecot/dovecot-ldap.conf.ext'),
    mode    => '0600',
    owner   => root,
    group   => dovecot,
    before  => Exec['dovecot'],
  }

  file { '/etc/dovecot/dovecot-ldap-userdb.conf.ext':
    ensure  => present,
    content => template('dovecot/dovecot-ldap.conf.ext'),
    mode    => '0600',
    owner   => root,
    group   => dovecot,
    before  => Exec['dovecot'],
  }

  file { '/etc/dovecot/conf.d/auth-ldap.conf.ext':
    ensure  => present,
    content => template('dovecot/auth-ldap.conf.ext'),
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
    require     => File['/etc/dovecot/dovecot-ldap.conf.ext']
  }
}
