class learning::abalone {

  include ::abalone

  file_line { 'pam_securetty':
    path  => '/etc/pam.d/login',
    line  => '#auth [user_unknown=ignore success=ok ignore default=bad] pam_security.so',
    match => 'pam_securetty.so$',
  }

}
