# 10-logging.conf
# See README.md for usage
class dovecot::logging (
  Hash[String, Optional[String]] $options = {},
  Hash[String, Optional[String]] $plugins = {}
) {
  include ::dovecot

  dovecot::config::dovecotcfhash {'logging':
    config_file => 'conf.d/10-logging.conf',
    options     => $options,
  }

  dovecot::config::dovecotcfhash {'logging plugin':
    config_file => 'conf.d/10-logging.conf',
    options     => prefix($plugins, 'plugin/'),
  }
}
