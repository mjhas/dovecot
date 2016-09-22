# 10-auth.conf
# See README.md for usage
class dovecot::auth (
  Optional[Enum['yes','no']] $disable_plaintext_auth = undef,
  Optional[Integer] $auth_cache_size = undef,
  Optional[String] $auth_cache_ttl = undef,
  Optional[String] $auth_cache_negative_ttl = undef,
  Optional[String] $auth_realms = undef,
  Optional[String] $auth_default_realm = undef,
  Optional[String] $auth_username_chars = undef,
  Optional[String] $auth_username_translation = undef,
  Optional[String] $auth_username_format = undef,
  Optional[String] $auth_master_user_separator = undef,
  Optional[String] $auth_anonymous_username = undef,
  Optional[Integer] $auth_worker_max_count = undef,
  Optional[String] $auth_gssapi_hostname = undef,
  Optional[String] $auth_krb5_keytab = undef,
  Optional[Enum['yes','no']] $auth_use_winbind = undef,
  Optional[String] $auth_winbind_helper_path = undef,
  Optional[String] $auth_failure_delay = undef,
  Optional[Enum['yes','no']] $auth_ssl_require_client_cert = undef,
  Optional[Enum['yes','no']] $auth_ssl_username_from_cert = undef,
  String $auth_mechanisms = 'plain',
) {
  include ::dovecot

  if $auth_winbind_helper_path and !is_absolute_path($auth_winbind_helper_path) {
    fail("\$auth_winbind_helper_path must be an absolute path (${auth_winbind_helper_path} given)")
  }

  dovecot::config::dovecotcfhash {'auth':
    config_file => 'conf.d/10-auth.conf',
    options     => {
      disable_plaintext_auth       => $disable_plaintext_auth,
      auth_cache_size              => $auth_cache_size,
      auth_cache_ttl               => $auth_cache_ttl,
      auth_cache_negative_ttl      => $auth_cache_negative_ttl,
      auth_realms                  => $auth_realms,
      auth_default_realm           => $auth_default_realm,
      auth_username_chars          => $auth_username_chars,
      auth_username_translation    => $auth_username_translation,
      auth_username_format         => $auth_username_format,
      auth_master_user_separator   => $auth_master_user_separator,
      auth_anonymous_username      => $auth_anonymous_username,
      auth_worker_max_count        => $auth_worker_max_count,
      auth_gssapi_hostname         => $auth_gssapi_hostname,
      auth_krb5_keytab             => $auth_krb5_keytab,
      auth_use_winbind             => $auth_use_winbind,
      auth_winbind_helper_path     => $auth_winbind_helper_path,
      auth_failure_delay           => $auth_failure_delay,
      auth_ssl_require_client_cert => $auth_ssl_require_client_cert,
      auth_ssl_username_from_cert  => $auth_ssl_username_from_cert,
      auth_mechanisms              => $auth_mechanisms,
    },
  }
}

