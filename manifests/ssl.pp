class dovecot::ssl (
  $ssl          = 'no',
  $ssl_certfile = false,
  $ssl_keyfile  = false,
  $ssl_ca       = false,
  ) {

  include dovecot

  dovecot::config::dovecotcfsingle { 'ssl':
    config_file => 'conf.d/10-ssl.conf',
    value       => $ssl,
  }

  dovecot::config::dovecotcfsingle { 'ssl_cert':
    ensure      => $ssl_certfile ? { false => absent, default => present },
    config_file => 'conf.d/10-ssl.conf',
    value       => "<${ssl_certfile}",
  }

  dovecot::config::dovecotcfsingle { 'ssl_key':
    ensure      => $ssl_keyfile ? { false => absent, default => present },
    config_file => 'conf.d/10-ssl.conf',
    value       => "<${ssl_keyfile}",
  }

  dovecot::config::dovecotcfsingle { 'ssl_ca':
    ensure      => $ssl_ca ? { false => absent, default => present },
    config_file => 'conf.d/10-ssl.conf',
    value       => "<${ssl_ca}",
  }
}
