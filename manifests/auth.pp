# 10-auth.conf
# See README.md for usage
class dovecot::auth (
  Hash[String, Optional[String]] $options = {},
  Hash[String, Hash] $unix_listeners      = {},
) {
  include ::dovecot

  dovecot::config::dovecotcfhash {'auth':
    config_file => 'conf.d/10-auth.conf',
    options     => $options,
  }

  dovecot::master::service {'auth':
    ensure  => 'present',
  }

  # Configure unix_listeners included in $unix_listeners
  $unix_listeners.each |String $k, Hash $opt| {
    dovecot::auth::unix_listener {$k:
      * => $opt,
    }
  }
}

