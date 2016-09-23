# 20-imap.conf
# See README.md for usage
class dovecot::imap (
  Hash[String, Optional[Variant[String,Integer]]] $options          = {},
  Hash[String, Optional[Variant[String,Integer]]] $protocol_options = {},
  Hash[String, Optional[Variant[String,Integer]]] $service_options  = {},
  Hash[String, Optional[Variant[String,Integer]]] $login_options    = {},
  Hash[String, Hash]                              $inet_listeners   = {},
) {
  include ::dovecot

  ensure_packages('dovecot-imapd')

  dovecot::config::dovecotcfhash {'imap':
    config_file => 'conf.d/20-imap.conf',
    options     => merge( $options, prefix($protocol_options, "protocol[. = \"imap\"]/") ),
  }

  dovecot::master::service {'imap':
    ensure  => 'present',
    options => $service_options,
  }

  dovecot::master::service {'imap-login':
    ensure  => 'present',
    options => $login_options,
  }

  # Configure inet_listeners included in $inet_listeners
  $inet_listeners.each |String $k, Hash $opt| {
    dovecot::imap::inet_listener {$k:
      * => $opt,
    }
  }
}
