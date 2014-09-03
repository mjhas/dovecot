# dovecot.conf
class dovecot::base (
  $protocols = 'imap',
  $listen    = '* , ::',
) {
  include dovecot

  dovecot::config::dovecotcfmulti { 'base':
    config_file => 'dovecot.conf',
    changes     => [
      "set protocols '${protocols}'",
      "set listen '${listen}'",
      ],
  }
}
