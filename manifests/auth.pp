# 10-auth.conf
# See README.md for usage
class dovecot::auth (
  Hash[String, Optional[String]] $options = {},
) {
  include ::dovecot

  dovecot::config::dovecotcfhash {'auth':
    config_file => 'conf.d/10-auth.conf',
    options     => $options,
  }
}

