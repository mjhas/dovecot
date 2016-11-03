# 20-managesieve.conf
# See README.md for usage
class dovecot::managesieved (
  Hash[String, Optional[Variant[String,Integer]]] $options          = {},
  Hash[String, Optional[Variant[String,Integer]]] $protocol_options = {},
  Hash[String, Optional[Variant[String,Integer]]] $service_options  = {},
  Hash[String, Optional[Variant[String,Integer]]] $login_options    = {},
  Hash[String, Hash]                              $inet_listeners   = {},
) {
  include ::dovecot

  $package_name = $::osfamily ? {
    'Debian' => 'dovecot-managesieved',
    'Redhat' => 'dovecot-pigeonhole',
    default  => 'dovecot-managesieved',
  }

  package { $package_name :
    ensure => installed,
    before => Exec['dovecot'],
    alias  => 'dovecot-managesieved',
  }

  dovecot::master::service {'managesieve-login':
    ensure      => 'present',
    config_file => 'conf.d/20-managesieve.conf',
    options     => $login_options,
    require     => Package[$package_name],
  }

  # Configure inet_listeners for managesieve
  $inet_listeners.each |String $k, Hash $opt| {
    dovecot::managesieved::inet_listener {$k:
      * => $opt,
    }
  }

  dovecot::master::service {'managesieve':
    ensure      => 'present',
    config_file => 'conf.d/20-managesieve.conf',
    options     => $service_options,
    require     => Package[$package_name],
  }

  dovecot::config::dovecotcfhash {'managesieve':
    config_file => 'conf.d/20-managesieve.conf',
    options     => merge( $options, prefix($protocol_options, "protocol[. =\"sieve\"]/") ),
    require     => Package[$package_name],
  }
}
