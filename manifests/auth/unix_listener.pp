#
define dovecot::auth::unix_listener (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $user            = undef,
  Optional[String] $group           = undef,
  Optional[String] $mode            = undef,
) {
  dovecot::config::listener {"auth unix_listener ${name}":
    ensure        => $ensure,
    type          => 'unix',
    service       => 'auth',
    listener_name => $name,
    options       => {
      user  => $user,
      group => $group,
      mode  => $mode,
    },
    require       => Dovecot::Config::Dovecotcfmulti['service auth'],
  }
}
