class dovecot::ssl (
  $ssl = 'no',
  $ssl_certfile = undef,
  $ssl_keyfile = undef,
  $ssl_ca = undef,
) {
  include dovecot

  dovecot::config::dovecotcfsingle { 'ssl':
    config_file => 'conf.d/10-ssl.conf',
    value       => $ssl,
  }

  if $ssl == 'yes' {
    dovecot::config::dovecotcfsingle { 'ssl_cert':
      config_file => 'conf.d/10-ssl.conf',
      value       => "<${ssl_certfile}",
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

    dovecot::config::dovecotcfsingle { 'ssl_key':
      config_file => 'conf.d/10-ssl.conf',
      value       => "<${ssl_keyfile}",
    }
  }
}
