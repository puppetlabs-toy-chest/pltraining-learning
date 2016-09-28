class learning::abalone {

  include ::abalone

  range("0","9").each |Integer $number| {
    file_line { "securetty_pts_${number}":
      path => '/etc/securetty',
      line => "pts/${number}"
    }
  }

  file_line { "system-auth":
    path   => '/etc/pam.d/system-auth',
    match  => 'account\s+sufficient\s+pam_succeed_if\.so uid < 1000 quiet',
    line   => '#account     sufficient pam_succeed_if.so uid < 1000 quiet',
  }

}
