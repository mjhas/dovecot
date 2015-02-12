# 20-lmtp.conf
class dovecot::lmtp (
  $mail_plugins       = '$mail_plugins',
  $postmaster_address = "root@${::fqdn}",
  $lmtp_path          = '/var/spool/postfix/private/dovecot-lmtp',
  ) {
  include dovecot
  include dovecot::master # Must be included so that dovecot::master::postfix_* resolve

  # See the [Dovecot wiki](http://wiki2.dovecot.org/HowTo/PostfixDovecotLMTP) for more information.
  # This setup is targeted toward use with Postfix via a unix socket.

  $package_name = $::osfamily ? {
    'Debian' => 'dovecot-lmtpd',
    'Redhat' => 'dovecot',
    default  => 'dovecot-lmtpd',
  }

  package { $package_name:
    ensure => installed,
    alias  => 'dovecot-lmtpd',
    before => Exec['dovecot']
  }

  if $dovecot::base::protocols !~ /lmtp/ {
    fail('lmtp must be added to dovecot::base::protocols, see http://wiki2.dovecot.org/LMTP')
  }

  dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/20-lmtp':
    config_file => 'conf.d/20-lmtp.conf',
    changes     => [
      "set protocol[ . = \"lmtp\"]/mail_plugins \"${mail_plugins}\"",
      "set protocol[ . = \"lmtp\"]/postmaster_address \"${postmaster_address}\"",
      ],
  }

  dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-lmtp0':
    config_file => 'conf.d/10-master.conf',
    onlyif      => "match service[ . = \"lmtp\"]/unix_listener[ . = \"${lmtp_path}\"] size == 0 ",
    changes     => [
      "ins unix_listener after service[ . = \"lmtp\"]/unix_listener[last()]",
      "set service[ . = \"lmtp\"]/unix_listener[last()] \"${lmtp_path}\"",
      "set service[ . = \"lmtp\"]/unix_listener[ . = \"${lmtp_path}\"]/mode \"${dovecot::master::postfix_mod}\"",
      "set service[ . = \"lmtp\"]/unix_listener[ . = \"${lmtp_path}\"]/user \"${dovecot::master::postfix_username}\"",
      "set service[ . = \"lmtp\"]/unix_listener[ . = \"${lmtp_path}\"]/group \"${dovecot::master::postfix_groupname}\"",
      ],
  }

  dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-lmtp1':
    config_file => 'conf.d/10-master.conf',
    onlyif      => "match service[ . = \"lmtp\"]/unix_listener[ . = \"${lmtp_path}\"] size == 1 ",
    changes     => [
      "set service[ . = \"lmtp\"]/unix_listener[ . = \"${lmtp_path}\"]/mode \"${dovecot::master::postfix_mod}\"",
      "set service[ . = \"lmtp\"]/unix_listener[ . = \"${lmtp_path}\"]/user \"${dovecot::master::postfix_username}\"",
      "set service[ . = \"lmtp\"]/unix_listener[ . = \"${lmtp_path}\"]/group \"${dovecot::master::postfix_groupname}\"",
      ],
    require     => Dovecot::Config::Dovecotcfmulti['/etc/dovecot/conf.d/10-master.conf-lmtp0'],
  }
}
