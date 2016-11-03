# 90-plugin.conf
# See README.md for usage
define dovecot::plugin (
  Hash[String, Optional[Variant[String,Integer]]] $options = {},
  String $config_file = 'conf.d/90-plugin.conf',
) {
  include ::dovecot

  dovecot::config::dovecotcfhash {"plugin ${name}":
    config_file => $config_file,
    options     => prefix($options, 'plugin/'),
  }
}
