#
# See README.md for usage
define dovecot::imap::inet_listener (
  Enum['present', 'absent'] $ensure   = 'present',
  Optional[String] $address           = undef,
  Optional[Integer] $port             = undef,
  Optional[Enum['yes','no']] $ssl     = undef,
  Optional[Enum['yes','no']] $haproxy = undef,
) {
  dovecot::config::listener {"imap inet_listener ${name}":
    ensure        => $ensure,
    type          => 'inet',
    service       => 'imap-login',
    listener_name => $name,
    options       => {
      address => $address,
      port    => $port,
      ssl     => $ssl,
      haproxy => $haproxy,
    },
    require       => Dovecot::Config::Dovecotcfmulti['service imap-login'],
  }
}
