# Internal define
# It takes a hash with option => value mappings and creates a
# dovecotcfsingle for each of them. If an option has undef as value, then it
# is removed
define dovecot::config::dovecotcfhash(
  Hash $options,
  $config_file = 'dovecot.conf',
) {
  $options.each |String $key, Optional[Variant[String,Integer]] $value| {
    $ensure = $value ? {
      undef   => 'absent',
      default => 'present',
    }

    dovecot::config::dovecotcfsingle {"dovecotcfhash ${name}:${key}":
      ensure      => $ensure,
      config_file => $config_file,
      option      => $key,
      value       => $value,
    }
  }
}
