# 10-ssl.conf
class dovecot::ssl (
  $ssl               = 'no',
  $ssl_certfile      = false,
  $ssl_keyfile       = false,
  $ssl_ca            = false,
  $ssl_key_pass_file = false,
  $ssl_cipher_list   = false,
  $ssl_prefer_server_ciphers = false,
) {
  include dovecot

  dovecot::config::dovecotcfsingle { 'ssl':
    config_file => 'conf.d/10-ssl.conf',
    value       => $ssl,
  }

  # note that the < on the values for these is intential, it basically says read the contents of the file into the config
  # this wasn't actually working last time I tried, but neither was the password in-line in this file
  # not putting password on key file for time being
  dovecot::config::dovecotcfsingle { 'ssl_key_password':
    ensure      => $ssl_key_pass_file ? { false => absent, default => present },
    config_file => 'conf.d/10-ssl.conf',
    value       => "<${ssl_key_pass_file}",
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

  if $ssl_cipher_list != false {
    dovecot::config::dovecotcfsingle { 'ssl_cipher_list':
      config_file => 'conf.d/10-ssl.conf',
      value       => $ssl_cipher_list,
    }
  }

  if $ssl_prefer_server_ciphers != false {
    dovecot::config::dovecotcfsingle { 'ssl_prefer_server_ciphers':
      config_file => 'conf.d/10-ssl.conf',
      value       => $ssl_prefer_server_ciphers,
    }
  }
}
