class dovecot::mail (
  $username      = 'vmail',
  $groupname     = 'vmail',
  $gid           = 5000,
  $uid           = 5000,
  $mailstoretype = 'maildir',
  $userhome      = '/srv/vmail',
  $mailstorepath = '/srv/vmail/%d/%n/',
  $mailplugins   = 'quota',
) {
  include dovecot
    
  dovecot::config::dovecotcfmulti { 'mail':
    config_file => 'conf.d/10-mail.conf',
    changes     => [
      "set mail_location '${mailstoretype}:${mailstorepath}'",
      "set mail_uid ${uid}",
      "set mail_gid ${gid}",
      "set first_valid_uid ${uid}",
      "set last_valid_uid  ${uid}",
      "set first_valid_gid ${gid}",
      "set last_valid_gid ${gid}",
      "set mail_plugins '${$mailplugins}'",
      ],
  }

  group { $groupname:
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
}