# 10-master.conf
class dovecot::master (
  $username          = 'vmail',
  $groupname         = 'vmail',
  $mod               = '0600',
  $postfix           = false,
  $postfix_username  = 'postfix',
  $postfix_groupname = 'postfix',
  $postfix_mod       = '0666',
  $postfix_path      = '/var/spool/postfix/private/auth',
  $auth_worker_user  = '$default_internal_user',
  $auth_worker_group = false,
) {
  include dovecot

  if $postfix == true {
    dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-postfixlistener0':
      config_file => 'conf.d/10-master.conf',
      onlyif      => "match service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"] size == 0 ",
      changes     => [
        "ins unix_listener after service[ . = \"auth\"]/unix_listener[last()]",
        "set service[ . = \"auth\"]/unix_listener[last()] \"${postfix_path}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/mode \"${postfix_mod}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/user \"${postfix_username}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/group \"${postfix_groupname}\"",
        ],
    }

    dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-postfixlistener1':
      config_file => 'conf.d/10-master.conf',
      onlyif      => "match service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"] size == 1 ",
      changes     => [
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/mode \"${postfix_mod}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/user \"${postfix_username}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/group \"${postfix_groupname}\"",
        ],
      require     => Dovecot::Config::Dovecotcfmulti['/etc/dovecot/conf.d/10-master.conf-postfixlistener0'],
      before      => Dovecot::Config::Dovecotcfmulti['/etc/dovecot/conf.d/10-master.conf-userdblistener0'],
    }
  }

  dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-userdblistener0':
    config_file => 'conf.d/10-master.conf',
    onlyif      => 'match service[ . = "auth"]/unix_listener[ . = "auth-userdb"] size == 0 ',
    changes     => [
      "ins unix_listener after service[ . = \"auth\"]/unix_listener[last()]",
      'set service[ . = "auth"]/unix_listener[last()] "auth-userdb"',
      "set service[ . = \"auth\"]/unix_listener[ . = \"auth-userdb\"]/mode \"${mod}\"",
      "set service[ . = \"auth\"]/unix_listener[ . = \"auth-userdb\"]/user \"${username}\"",
      "set service[ . = \"auth\"]/unix_listener[ . = \"auth-userdb\"]/group \"${groupname}\"",
      ],
  }

  dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-userdblistener1':
    config_file => 'conf.d/10-master.conf',
    onlyif      => 'match service[ . = "auth"]/unix_listener[ . = "auth-userdb"] size == 1 ',
    changes     => [
      "set service[ . = \"auth\"]/unix_listener[ . = \"auth-userdb\"]/mode \"${mod}\"",
      "set service[ . = \"auth\"]/unix_listener[ . = \"auth-userdb\"]/user \"${username}\"",
      "set service[ . = \"auth\"]/unix_listener[ . = \"auth-userdb\"]/group \"${groupname}\"",
      ],
    require     => Dovecot::Config::Dovecotcfmulti['/etc/dovecot/conf.d/10-master.conf-userdblistener0'],
  }

  dovecot::config::dovecotcfsingle { "service[ . = \"auth-worker\"]/user":
    ensure      => $auth_worker_user ? { false => absent, default => present },
    config_file => 'conf.d/10-master.conf',
    value       => $auth_worker_user,
  }

  dovecot::config::dovecotcfsingle { "service[ . = \"auth-worker\"]/group":
    ensure      => $auth_worker_group ? { false => absent, default => present },
    config_file => 'conf.d/10-master.conf',
    value       => $auth_worker_group,
  }
}
