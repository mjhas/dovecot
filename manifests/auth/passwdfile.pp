# See README.md for usage
define dovecot::auth::passwdfile (
  Enum['present','absent'] $ensure  = 'present',
  String $scheme                    = 'CRYPT',
  String $username_format           = '%u',
  String $user_file                 = '/etc/dovecot/users',
  Optional[String] $default_fields  = undef,
  Optional[String] $override_fields = undef,
) {
  if !is_absolute_path($user_file) {
    fail("\$user_file must be an absolute path (${user_file} given)")
  }

  file {"/etc/dovecot/conf.d/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('dovecot/auth/passwdfile.epp', {
        scheme          => $scheme,
        username_format => $username_format,
        user_file       => $user_file,
        default_fields  => $default_fields,
        override_fields => $override_fields,
    } ),
    notify  => Service['dovecot'],
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
