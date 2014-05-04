class dovecot::ssl (
  $ssl          = 'no',
  $ssl_certfile = undef,
  $ssl_keyfile  = undef,
  $ssl_ca       = undef,
  ) {

  include dovecot

  dovecot::config::dovecotcfsingle { 'ssl':
    config_file => 'conf.d/10-ssl.conf',
    value       => $ssl,
  }

  if $ssl_certfile != undef {
    dovecot::config::dovecotcfsingle { 'ssl_cert':
      config_file => 'conf.d/10-ssl.conf',
      value       => "<${ssl_certfile}",
    }
  } else {
    dovecot::config::dovecotcfsingle { 'ssl_cert':
      ensure      => absent,
      config_file => 'conf.d/10-ssl.conf',
    }
  }

  if $ssl_ca != undef {
    dovecot::config::dovecotcfsingle { 'ssl_ca':
      config_file => 'conf.d/10-ssl.conf',
      value       => "<${ssl_ca}",
    }
  } else {
    dovecot::config::dovecotcfsingle { 'ssl_ca':
      ensure      => absent,
      config_file => 'conf.d/10-ssl.conf',
    }
  }

  if $ssl_keyfile != undef {
    dovecot::config::dovecotcfsingle { 'ssl_key':
      config_file => 'conf.d/10-ssl.conf',
      value       => "<${ssl_keyfile}",
    }
  } else {
    dovecot::config::dovecotcfsingle { 'ssl_key':
      ensure      => absent,
      config_file => 'conf.d/10-ssl.conf',
    }
  }
}
