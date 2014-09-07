class dovecot::managesieved {

  include dovecot

  $package_name = $::osfamily ? {
    'Debian' => 'dovecot-managesieved',
    'Redhat' => 'dovecot-pigeonhole',
    default  => 'dovecot-managesieved',
  }

  package { $package_name :
      ensure  => installed,
      before  => Exec['dovecot'],
      require => Package['dovecot'],
      alias   => 'dovecot-managesieved',
  }

  dovecot::config::dovecotcfmulti { 'managesieved-plugin':
    config_file => 'conf.d/20-managesieve.conf',
    changes     => [
      "set service[1] 'managesieve'",
      "set service[2] 'managesieve-login'",
      ],
  }

}
