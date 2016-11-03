#
# See README.md for usage
define dovecot::auth::system (
  Enum['present','absent'] $ensure  = 'present',
  Array[Struct[{
        driver => Enum['pam','passwd','shadow','bsdauth'],
        args   => Optional[String],
  }]] $passdb                       = [ { driver =>  'pam' }],
  Array[Struct[{
        driver => Enum['pam','passwd','shadow','bsdauth'],
        args   => Optional[String],
  }]] $userdb                       = [ { driver =>  'passwd' } ],
  Optional[String] $default_fields  = undef,
  Optional[String] $override_fields = undef,
  Optional[String] $source          = undef,
) {

  file {"/etc/dovecot/conf.d/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['dovecot'],
    source  => $source,
    content => epp('dovecot/auth/system.epp', {
        passdb => $passdb,
        userdb => $userdb,
    } ),
  }

  if $ensure == 'present' {
    dovecot::config::dovecotcfmulti {"Add auth ${name}":
      config_file => 'conf.d/10-auth.conf',
      onlyif      => "values include not_include ${name}",
      changes     => [
        "set include[last()+1] ${name}",
      ],
    }
  } else {
    dovecot::config::dovecotcfmulti {"remove include ${name}":
      config_file => 'conf.d/10-auth.conf',
      onlyif      => "values include include ${name}",
      changes     => [ "rm include[. = \"${name}\"]" ],
    }
  }
}
