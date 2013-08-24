include dovecot
include dovecot::ssl
include dovecot::sieve
include dovecot::master
class { 'dovecot::postgres':
  dbname     => 'dbname',
  dbpassword => 'dbpassword',
  dbusername => 'dbusername',
}
include dovecot::mail
include dovecot::lda
include dovecot::imap
include dovecot::base
include dovecot::auth
