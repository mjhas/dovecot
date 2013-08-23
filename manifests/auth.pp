class dovecot::auth (
  $disable_plaintext_auth = 'no',
  $auth_mechanisms        = 'plain login',
) {
  include dovecot

  dovecot::config::dovecotcfmulti { 'auth':
    config_file => 'conf.d/10-auth.conf',
    changes     => [
      "set disable_plaintext_auth '${disable_plaintext_auth}'",
      "set auth_mechanisms '${auth_mechanisms}'",
    ],
  }
}
