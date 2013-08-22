class dovecot::imap ($mail_plugins = '$mail_plugins imap_quota') {
  include dovecot
  
  dovecot::config::dovecotcfsingle { 'mail_plugins':
    config_file => 'conf.d/20-imap.conf',
    value       => $mail_plugins,
  }
}