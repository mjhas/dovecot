class dovecot::auth (
  $disable_plaintext_auth = 'no',
  $auth_mechanisms        = 'plain login',
  $auth_default_realm     = 'example.com'
) {
  include dovecot

  dovecot::config::dovecotcfmulti { 'auth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "set disable_plaintext_auth '${disable_plaintext_auth}'",
      "set auth_mechanisms '${auth_mechanisms}'",
      "set auth_username_format '%Ln'",
      "set auth_default_realm '${auth_default_realm}'"
    ],
  }
}
