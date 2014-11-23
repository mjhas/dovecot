class dovecot {

  Package <| tag == 'dovecot' |> ->
  Augeas  <| tag == 'dovecot' |> ->
  Service <| tag == 'dovecot' |>

  $mailpackages = $::osfamily ? {
    default  => ['dovecot-imapd', 'dovecot-pop3d'],
    'Debian' => ['dovecot-imapd', 'dovecot-pop3d'],
    'Redhat' => ['dovecot',]
  }

  package {[$mailpackages]:
    ensure => present,
    tag    => 'dovecot',
  }


  service { 'dovecot':
    ensure  => running,
    enable  => true,
    tag    => 'dovecot',
  }
}
