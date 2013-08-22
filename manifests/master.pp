class dovecot::master (
  $username          = 'vmail',
  $groupname         = 'vmail',
  $mod               = '0600',
  $postfix           = false,
  $postfix_username  = 'postfix',
  $postfix_groupname = 'postfix',
  $postfix_mod       = '0666',
  $postfix_path      = '/var/spool/postfix/private/auth',
) {
  include dovecot
  
  if $postfix == true {
    dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-postixlistener0':
      config_file => 'conf.d/10-master.conf',
      onlyif      => "match service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"] size == 0 ",
      changes     => [
        "set service[ . = \"auth\"]/unix_listener[last()+1] \"${postfix_path}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/mode \"${postfix_mod}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/user \"${postfix_username}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/group \"${postfix_groupname}\"",
        ],
    }

    dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-postixlistener1':
      config_file => 'conf.d/10-master.conf',
      onlyif      => "match service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"] size == 1 ",
      changes     => [
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/mode \"${postfix_mod}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/user \"${postfix_username}\"",
        "set service[ . = \"auth\"]/unix_listener[ . = \"${postfix_path}\"]/group \"${postfix_groupname}\"",
        ],
      require     => Dovecot::Config::Dovecotcfmulti['/etc/dovecot/conf.d/10-master.conf-postixlistener0'],
      before      => Dovecot::Config::Dovecotcfmulti['/etc/dovecot/conf.d/10-master.conf-userdblistener0'],
    }
  }

  dovecot::config::dovecotcfmulti { '/etc/dovecot/conf.d/10-master.conf-userdblistener0':
    config_file => 'conf.d/10-master.conf',
    onlyif      => 'match service[ . = "auth"]/unix_listener[ . = "auth-userdb"] size == 0 ',
    changes     => [
      'set service[ . = "auth"]/unix_listener[last()+1] "auth-userdb"',
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

  dovecot::config::dovecotcfmulti { 'master':
    config_file => 'conf.d/10-master.conf',
    changes     => ['set service[ . = "auth-worker"]/user $default_internal_user',],
    require     => [
      File['/usr/share/augeas/lenses/dist/dovecot.aug'],
      Dovecot::Config::Dovecotcfmulti['/etc/dovecot/conf.d/10-master.conf-userdblistener1']]
  }
}