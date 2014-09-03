# 10-logging.conf
class dovecot::logging (
  $auth_verbose         = 'no',
  $auth_debug           = 'no',
  $auth_debug_passwords = 'no',
  $mail_debug           = 'no',
  $verbose_ssl          = 'no',
  $log_timestamp        = '%b %d %H:%M:%S ',
) {
  include dovecot

  dovecot::config::dovecotcfsingle { 'auth_verbose':
    config_file => 'conf.d/10-logging.conf',
    value       => $auth_verbose,
  }

  dovecot::config::dovecotcfsingle { 'auth_debug':
    config_file => 'conf.d/10-logging.conf',
    value       => $auth_debug,
  }

  dovecot::config::dovecotcfsingle { 'auth_debug_passwords':
    config_file => 'conf.d/10-logging.conf',
    value       => $auth_debug_passwords,
  }

  dovecot::config::dovecotcfsingle { 'mail_debug':
    config_file => 'conf.d/10-logging.conf',
    value       => $mail_debug,
  }

  dovecot::config::dovecotcfsingle { 'verbose_ssl':
    config_file => 'conf.d/10-logging.conf',
    value       => $verbose_ssl,
  }

  if $log_timestamp != false {
    dovecot::config::dovecotcfsingle { 'log_timestamp':
      config_file => 'conf.d/10-logging.conf',
      value       => "\"${log_timestamp}\"",
    }
  }
}
