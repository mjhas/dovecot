# 10-auth.conf
class dovecot::auth (
  $disable_plaintext_auth = 'no',
  $auth_mechanisms        = 'plain login',
  $auth_username_format   = '%Ln',
  $auth_default_realm     = $::fqdn,
) {
  include dovecot

  dovecot::config::dovecotcfmulti { 'auth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "set disable_plaintext_auth '${disable_plaintext_auth}'",
      "set auth_mechanisms '${auth_mechanisms}'",
      "set auth_username_format '${auth_username_format}'",
      "set auth_default_realm '${auth_default_realm}'"
    ],
  }
}
