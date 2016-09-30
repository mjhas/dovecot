# 15-mailboxes.conf
# See README.md for usage
#
# Augeas no me deja poner las opciones \Drafts, etc, así que lo defino
# con un template y tengo que hacerlo con un template
define dovecot::namespace (
  Enum['present','absent'] $ensure                  = present,
  Optional[Enum['private','shared','public']] $type = undef,
  Optional[String] $separator                       = undef,
  Optional[String] $prefix                          = undef,
  Optional[String] $location                        = undef,
  Enum['yes','no'] $inbox                           = 'no',
  Optional[Enum['yes','no']] $hidden                = undef,
  Optional[Enum['yes','no', 'children']] $list      = undef,
  Optional[Enum['yes','no']] $subscriptions         = undef,
  Hash $mailboxes                                   = {},
) {
  $path = $name ? {
    'inbox' => '/etc/dovecot/conf.d/15-mailboxes.conf',
    default => "/etc/dovecot/conf.d/15-namespace_${name}.conf",
  }

  file {$path:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('dovecot/namespace.epp', {
        name          => $name,
        type          => $type,
        separator     => $separator,
        prefix        => $prefix,
        location      => $location,
        inbox         => $inbox,
        hidden        => $hidden,
        list          => $list,
        subscriptions => $subscriptions,
        mailboxes     => $mailboxes,
    } ),
    notify  => Service['dovecot'],
  }
}
