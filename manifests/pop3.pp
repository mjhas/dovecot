# 20-pop3.conf
# See README.md for usage
class dovecot::pop3 (
  Hash[String, Optional[Variant[String,Integer]]] $options          = {},
  Hash[String, Optional[Variant[String,Integer]]] $protocol_options = {},
  Hash[String, Optional[Variant[String,Integer]]] $service_options  = {},
  Hash[String, Optional[Variant[String,Integer]]] $login_options    = {},
  Hash[String, Hash]                              $inet_listeners   = {},
) {
  include ::dovecot

  ensure_packages('dovecot-pop3d')

  dovecot::config::dovecotcfhash {'pop3':
    config_file => 'conf.d/20-pop3.conf',
    options     => merge( $options, prefix($protocol_options, "protocol[. = \"pop3\"]/") ),
  }

  dovecot::master::service {'pop3':
    ensure  => 'present',
    options => $service_options,
  }

  dovecot::master::service {'pop3-login':
    ensure  => 'present',
    options => $login_options,
  }

  # Configure inet_listeners included in $inet_listeners
  $inet_listeners.each |String $k, Hash $opt| {
    dovecot::pop3::inet_listener {$k:
      * => $opt,
    }
  }
}
