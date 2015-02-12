# 10-mail.conf
# 15-mailboxes.conf
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
  $lock_method             = 'fcntl',
  $mbox_read_locks         = 'fcntl',
  $mbox_write_locks        = 'dotlock fcntl',
  $mail_nfs_storage        = 'no',
  $mail_nfs_index          = 'no',
  $mmap_disable            = 'no',
  $mail_fsync              = 'optimized'
) {
  include dovecot

  if ( $mail_nfs_index == 'yes' and $mmap_disable != 'yes' ) {
    fail('mail_nfs_index=yes requires mmap_disable=yes')
  }

  if ( $mail_nfs_index == 'yes' and $mail_fsync != 'always' ) {
    fail('mail_nfs_index=yes requires mail_fsync=always')
  }

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
      "set mail_plugins '${mailplugins}'",
      "set lock_method '${lock_method}'",
      "set mbox_read_locks '${mbox_read_locks}'",
      "set mbox_write_locks '${mbox_write_locks}'",
      "set mail_nfs_storage '${mail_nfs_storage}'",
      "set mail_nfs_index '${mail_nfs_index}'",
      "set mmap_disable '${mmap_disable}'",
      "set mail_fsync '${mail_fsync}'",
    ],
  }
  if $manage_mailboxfile {
    file { '/etc/dovecot/conf.d/15-mailboxes.conf':
      ensure  => present,
      content => template($mailboxtemplate),
      mode    => '0644',
      owner   => root,
      group   => root,
      before  => Exec['dovecot'],
    }
  }

  if !defined(Group[$groupname]) {
    group { $groupname :
      ensure => present,
      gid    => $gid,
    }
  }

  if !defined(User[$username]) {
    user { $username:
      ensure     => present,
      gid        => $gid,
      home       => $userhome,
      managehome => false,
      uid        => $uid,
      require    => Group[$groupname]
    }
  }

  file { $userhome:
    ensure  => directory,
    owner   => $username,
    group   => $groupname,
    mode    => '0750',
    require => User[$username],
  }
}
