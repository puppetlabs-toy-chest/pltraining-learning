define learning::pypi_cached_pkg {

  include wget

  $basename = inline_template("<%= File.basename('${title}') %>")
  wget::fetch { $title:
    destination => "${pypi_pkg_dir}/${basename}",
  }

}
