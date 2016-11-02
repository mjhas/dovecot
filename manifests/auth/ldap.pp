#
# See README.md for usage
define dovecot::auth::ldap (
  Enum['present','absent'] $ensure                                        = 'present',
  Boolean $static                                                         = false,
  Boolean $prefetch                                                       = false,
  String $path                                                            = '/etc/dovecot/dovecot-ldap.conf.ext',
  String $owner                                                           = 'root',
  String $group                                                           = 'root',
  String $mode                                                            = '0600',
  Optional[String] $hosts                                                 = undef,
  Optional[String] $uris                                                  = undef,
  Optional[String] $dn                                                    = undef,
  Optional[String] $dnpass                                                = undef,
  Optional[Enum['yes','no']] $sasl_bind                                   = undef,
  Optional[String] $sasl_mech                                             = undef,
  Optional[String] $sasl_realm                                            = undef,
  Optional[String] $sasl_authz_id                                         = undef,
  Optional[Enum['yes','no']] $tls                                         = undef,
  Optional[String] $tls_ca_cert_file                                      = undef,
  Optional[String] $tls_ca_cert_dir                                       = undef,
  Optional[String] $tls_cipher_suite                                      = undef,
  Optional[String] $tls_cert_file                                         = undef,
  Optional[String] $tls_key_file                                          = undef,
  Optional[Enum['never','hard','demand','allow','try']] $tls_require_cert = undef,
  Optional[String] $ldaprc_path                                           = undef,
  Optional[Integer] $debug_level                                          = undef,
  Optional[Enum['yes','no']] $auth_bind                                   = undef,
  Optional[String] $auth_bind_userdn                                      = undef,
  Optional[String] $ldap_version                                          = undef,
  String $base                                                            = '',
  Optional[Enum['never','searching','finding','always']] $deref           = undef,
  Optional[Enum['base','onelevel','subtree']] $scope                      = undef,
  Optional[String] $user_attrs                                            = undef,
  Optional[String] $user_filter                                           = undef,
  Optional[String] $pass_attrs                                            = undef,
  Optional[String] $pass_filter                                           = undef,
  Optional[String] $iterate_attrs                                         = undef,
  Optional[String] $iterate_filter                                        = undef,
  Optional[String] $default_pass_scheme                                   = undef,
  Optional[String] $static_args                                           = undef,
  Optional[String] $default_fields                                        = undef,
) {
  ensure_packages('dovecot-ldap')

  $passdb_enabled = $pass_attrs or $pass_filter
  file {"/etc/dovecot/conf.d/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['dovecot'],
    content => epp('dovecot/auth/ldap.epp', {
        passdb              => $passdb_enabled,
        static              => $static,
        prefetch            => $prefetch,
        path                => $path,
        default_pass_scheme => $default_pass_scheme,
        static_args         => $static_args,
    } ),
  }

  file {$path:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    notify  => Service['dovecot'],
    content => epp('dovecot/auth/dovecot-ldap.epp', {
        hosts            => $hosts,
        uris             => $uris,
        dn               => $dn,
        dnpass           => $dnpass,
        sasl_bind        => $sasl_bind,
        sasl_mech        => $sasl_mech,
        sasl_realm       => $sasl_realm,
        sasl_authz_id    => $sasl_authz_id,
        tls              => $tls,
        tls_ca_cert_file => $tls_ca_cert_file,
        tls_ca_cert_dir  => $tls_ca_cert_dir,
        tls_cipher_suite => $tls_cipher_suite,
        tls_cert_file    => $tls_cert_file,
        tls_key_file     => $tls_key_file,
        tls_require_cert => $tls_require_cert,
        ldaprc_path      => $ldaprc_path,
        debug_level      => $debug_level,
        auth_bind        => $auth_bind,
        auth_bind_userdn => $auth_bind_userdn,
        ldap_version     => $ldap_version,
        base             => $base,
        deref            => $deref,
        scope            => $scope,
        user_attrs       => $user_attrs,
        user_filter      => $user_filter,
        pass_attrs       => $pass_attrs,
        pass_filter      => $pass_filter,
        iterate_attrs    => $iterate_attrs,
        iterate_filter   => $iterate_filter,
    }),
  }

  if $ensure == 'present' {
    dovecot::config::dovecotcfmulti {"Add auth ${name}":
      config_file => 'conf.d/10-auth.conf',
      onlyif      => "values include not_include ${name}",
      changes     => [
        "set include[last()+1] ${name}",
      ],
    }
  } else {
    dovecot::config::dovecotcfmulti {"remove include ${name}":
      config_file => 'conf.d/10-auth.conf',
      onlyif      => "values include include ${name}",
      changes     => [ "rm include[. = \"${name}\"]" ],
    }
  }
}
