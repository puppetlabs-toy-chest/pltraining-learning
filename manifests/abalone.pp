class learning::abalone {

  class { '::abalone':
    bannerfile => '/etc/issue',
  }

  range("0","15").each |Integer $number| {
    file_line { "securetty_pts_${number}":
      path => '/etc/securetty',
      line => "pts/${number}"
    }
  }

}
