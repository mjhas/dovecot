# 10-ssl.conf
# See README.md for usage
class dovecot::ssl (
  Hash[String, Optional[Variant[String,Integer]]] $options          = {},
) {
  include ::dovecot

  dovecot::config::dovecotcfhash {'ssl':
    config_file => 'conf.d/10-ssl.conf',
    options     => $options,
  }
}
