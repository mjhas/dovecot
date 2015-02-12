# 15-lda.conf
class dovecot::lda (
  $postmaster_address = "root@${::fqdn}",
) {
  include dovecot

  dovecot::config::dovecotcfmulti { 'lda':
    config_file => 'conf.d/15-lda.conf',
    changes     => [
      "set postmaster_address '${postmaster_address}'",
      "set protocol[ . = 'lda']/mail_plugins '\$mail_plugins'",
    ],
  }
}
