# 90-plugin.conf
# See README.md for usage
define dovecot::plugin (
  Hash[String, Optional[Variant[String,Integer]]] $options = {},
) {
  include ::dovecot

  dovecot::config::dovecotcfhash {"plugin ${name}":
    config_file => 'conf.d/90-plugin.conf',
    options     => prefix($options, 'plugin/'),
  }
}
