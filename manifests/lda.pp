# 15-lda.conf
# See README.md for usage
class dovecot::lda (
  Hash[String,Optional[Variant[String,Integer]]] $options = {},
  Optional[String] $mail_plugins                          = undef,
) {
  include ::dovecot

  dovecot::config::dovecotcfhash {'lda':
    config_file => 'conf.d/15-lda.conf',
    options     => merge( $options, { 'protocol/mail_plugins' => $mail_plugins } ),
  }
}
