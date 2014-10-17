# dovecot #

master branch: [![Build Status](https://secure.travis-ci.org/mjhas/dovecot.png?branch=master)](http://travis-ci.org/mjhas/dovecot)

This is the dovecot module. It provides installation and configuration routines using Puppet.

Simplest Configuration:
=============


    include dovecot


It will just install the dovecot-imapd package and ensure that dovecot is running.

---------------------------------------

Real World Configuration:
=============

    include dovecot 

    class { dovecot::ssl:
      ssl          => 'yes',
      ssl_keyfile  => '/etc/ssl/private/example_privatekey.pem',
      ssl_certfile => '/etc/ssl/certs/example_server.pem',
      ssl_ca       => '/etc/ssl/certs/CAcert_chain.pem'
    }
    include dovecot::sieve
    class { dovecot::master:
      postfix    => yes
    }

    class { dovecot::postgres:
      dbname     => 'dbname',
      dbpassword => 'dbpassword',
      dbusername => 'dbuser',
    }
    include dovecot::mail

    class { dovecot::lda: 
      postmaster_address => 'postmaster@example.org'
    }
    include dovecot::imap
    include dovecot::base
    include dovecot::auth

Something more fancy.

## Contributors

[Andschwa](https://github.com/andschwa)
[hdeadman](https://github.com/hdeadman)
[WBasson](https://github.com/WBasson)
[tthayer](https://github.com/tthayer)

