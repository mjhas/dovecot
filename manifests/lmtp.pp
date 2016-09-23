# 20-lmtp.conf
class dovecot::lmtp (
  Hash[String, Optional[Variant[String,Integer]]] $options          = {},
  Hash[String, Optional[Variant[String,Integer]]] $protocol_options = {},
  Hash[String, Hash]                              $inet_listeners   = {},
  Hash[String, Hash]                              $unix_listeners   = {},
) {
  include ::dovecot

  ensure_packages('dovecot-lmtpd')

  dovecot::config::dovecotcfhash {'lmtp':
    config_file => 'conf.d/20-lmtp.conf',
    options     => merge( $options, prefix($protocol_options, "protocol[. = \"lmtp\"]/") ),
  }

  dovecot::master::service {'lmtp':
    ensure  => 'present',
  }

  # Configure inet_listeners included in $inet_listeners
  $inet_listeners.each |String $k, Hash $opt| {
    dovecot::lmtp::inet_listener {$k:
      * => $opt,
    }
  }

  # Configure unix_listeners included in $unix_listeners
  $unix_listeners.each |String $k, Hash $opt| {
    dovecot::lmtp::unix_listener {$k:
      * => $opt,
    }
  }
}
