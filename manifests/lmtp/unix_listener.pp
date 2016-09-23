#
define dovecot::lmtp::unix_listener (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $user            = undef,
  Optional[String] $group           = undef,
  Optional[String] $mode            = undef,
) {
  dovecot::config::listener {"lmtp unix_listener ${name}":
    ensure        => $ensure,
    type          => 'unix',
    service       => 'lmtp',
    listener_name => $name,
    options       => {
      user  => $user,
      group => $group,
      mode  => $mode,
    },
    require       => Dovecot::Config::Dovecotcfmulti['service lmtp'],
  }
}
