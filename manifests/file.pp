define homedir::file(
    $homedir_path = undef,
    $rel_path = undef,
    $group = undef,
    $mode  = undef,
    $target = undef,
    $recurse = undef,
    $ensure = 'present',
    $source = undef,
    $content = undef,
    $require = undef
) {
  $fn = "homedir::file"

  if defined(Homedir[$name]) {
    notify {"$fn Homedir[$name] is already defined": }
  } else {
    homedir {"$name":
      path => $homedir_path,
    }
  }

  if $homedir_path {
    $homedir_path_real = $homedir_path
  } elsif $name == 'root' {
    $homedir_path_real = $::osfamily ? {
      'Solaris' => '/',
      default   => '/root',
    }
  } else {
    $homedir_path_real = $::osfamily ? {
      'Solaris' => "/export/home/${name}",
      default   => "/home/${name}",
    }
  }
  notify {"$fn homedir_path_real: $homedir_path_real": }

  if $rel_path {
    #validate_re($rel_path, '^/')
    # If the home directory is not / (root on solaris) then disallow trailing slashes.
    validate_re($rel_path, '^[^/]')
  } else {
    fail("$fn rel_path is not set")
  }

  $path = "$homedir_path_real/$rel_path"
  notify {"$fn path: $path": }

  if defined(File[$path]) {
    notify {"$fn File[$path] is already defined": }
  } else {
    if $group {
      $group_real = $group
    } else {
      $group_real = $name
    }

    if defined(Group[$group_real]) {
      notify {"$fn Group[$group_real] is already defined": }
    } else {
      group { "$group_real":
        ensure => present,
      }
    }

    file { "$path":
      ensure => $ensure,
      owner  => $name,
      group  => $group_real,
      mode   => $mode,
      target => $target,
      recurse => $recurse,
      source => $source,
      content => $content,
      require => $require,
    }
    #fail("$fn File[$path_real] should be defined")
  }
  #ensure_resource('file', $name, {'ensure' => 'present'})
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
