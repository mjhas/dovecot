#
# Internal define to configure services in the 10-master config file
define dovecot::master::service (
  Enum['present','absent'] $ensure = 'present',
  Hash[String, Optional[Variant[String,Integer]]] $options = {},
  String $config_file = 'conf.d/10-master.conf',
) {
  if $ensure == 'present' {
    dovecot::config::dovecotcfmulti {"service ${name}":
      config_file => $config_file,
      onlyif      => "values service not_include ${name}",
      changes     => [ "set service[last()+1] ${name}", ],
    }

    dovecot::config::dovecotcfhash {"service ${name} options":
      config_file => $config_file,
      options     => prefix($options, "service[. = \"${name}\"]/"),
      require     => Dovecot::Config::Dovecotcfmulti["service ${name}"],
    }
  } else {
    dovecot::config::dovecotcfmulti {"remove service ${name}":
      config_file => $config_file,
      onlyif      => "values service include ${name}",
      changes     => [ "rm service[. = \"${name}\"]", ],
    }
  }
}
