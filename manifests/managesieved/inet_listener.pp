#
# See README.md for usage
define dovecot::managesieved::inet_listener (
  Enum['present', 'absent'] $ensure   = 'present',
  Optional[String] $address           = undef,
  Optional[Integer] $port             = undef,
  Optional[Enum['yes','no']] $ssl     = undef,
  Optional[Enum['yes','no']] $haproxy = undef,
) {
  dovecot::config::listener {"managesieve inet_listener ${name}":
    ensure        => $ensure,
    config_file   => 'conf.d/20-managesieve.conf',
    type          => 'inet',
    service       => 'managesieve-login',
    listener_name => $name,
    options       => {
      address => $address,
      port    => $port,
      ssl     => $ssl,
      haproxy => $haproxy,
    },
    require       => Dovecot::Config::Dovecotcfmulti['service managesieve-login'],
  }
}
