#
define dovecot::config::listener (
  String $service,
  String $listener_name,
  Hash $options,
  Enum['present','absent'] $ensure = 'present',
  Enum['unix','inet','fifo'] $type = 'unix',
  String $config_file = 'conf.d/10-master.conf',
) {
  $service_base = "service[ . = \"${service}\"]"
  $listener_base = "${type}_listener[ . = \"${listener_name}\"]"
  $r_options = prefix($options, "${service_base}/${listener_base}/")
  if $ensure == 'present' {
    dovecot::config::dovecotcfmulti {"${listener_name} ${type}_listener ${listener_name}":
      config_file => $config_file,
      onlyif      => "values ${service_base}/${type}_listener not_include ${listener_name}",
      changes     => [
        "set ${service_base}/${type}_listener[last()+1] ${listener_name}",
      ],
    }

    dovecot::config::dovecotcfhash {"${listener_name} ${type}_listener ${listener_name}":
      config_file => $config_file,
      options     => $r_options,
      require     => Dovecot::Config::Dovecotcfmulti["${listener_name} ${type}_listener ${listener_name}"],
    }
  } else {
    dovecot::config::dovecotcfmulti {"remove ${listener_name} ${type}_listener ${listener_name}":
      config_file => $config_file,
      onlyif      => "values ${service_base}/${type}_listener include ${listener_name}",
      changes     => [ "rm ${service_base}/${listener_base}" ],
    }
  }
}
