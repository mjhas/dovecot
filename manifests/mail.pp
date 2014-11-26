class dovecot::mail (
  $username                = 'vmail',
  $groupname               = 'vmail',
  $gid                     = 5000,
  $uid                     = 5000,
  $first_valid_uid         = 5000,
  $last_valid_uid          = 5000,
  $first_valid_gid         = 5000,
  $last_valid_gid          = 5000,
  $manage_mailboxfile      = true,
  $mailboxtemplate         = 'dovecot/15-mailboxes.conf',
  $mailstoretype           = 'maildir',
  $userhome                = '/srv/vmail',
  $mailstorepath           = '/srv/vmail/%d/%n/',
  # Set mailplugins to undef in the calling class
  # if no plugins are being used.
  $mailplugins             = 'quota',
  $manage_mbox_read_locks  = 'fcntl',
  $manage_mbox_write_locks = 'dotlock fcntl'
) {
  include dovecot

  dovecot::config::dovecotcfmulti { 'mail':
    config_file => 'conf.d/10-mail.conf',
    changes     => [
      "set mail_location '${mailstoretype}:${mailstorepath}'",
      "set mail_uid ${uid}",
      "set mail_gid ${gid}",
      "set first_valid_uid ${first_valid_uid}",
      "set last_valid_uid  ${last_valid_uid}",
      "set first_valid_gid ${first_valid_gid}",
      "set last_valid_gid ${last_valid_gid}",
      "set mail_plugins '${$mailplugins}'",
      "set mbox_read_locks '${manage_mbox_read_locks}'",
      "set mbox_write_locks '${manage_mbox_write_locks}'",
    ],
  }
  if $manage_mailboxfile {
    file { '/etc/dovecot/conf.d/15-mailboxes.conf':
      ensure  => present,
      content => template($mailboxtemplate),
      mode    => '0644',
      owner   => root,
      group   => root,
      require => Package['dovecot'],
    }
  }

  group { $groupname :
    ensure => present,
    gid    => $gid,
  }

  user { $username:
    ensure     => present,
    gid        => $gid,
    home       => $userhome,
    managehome => false,
    uid        => $uid,
    require    => Group[$groupname]
  }

  file { $userhome:
    ensure  => directory,
    owner   => $username,
    group   => $groupname,
    mode    => '0750',
    require => User[$username],
  }
}
