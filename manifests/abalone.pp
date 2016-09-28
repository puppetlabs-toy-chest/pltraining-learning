class learning::abalone {

  include ::abalone

  range("0","15").each |Integer $number| {
    file_line { "securetty_pts_${number}":
      path => '/etc/securetty',
      line => "pts/${number}"
    }
  }

}
