define homedir(
    $path = undef,
    $group = undef,
    $mode  = undef,
) {
  $fn = "homedir"

  homedir::user {"$name":
  }

  if $path {
    validate_re($path, '^/')
    # If the home directory is not / (root on solaris) then disallow trailing slashes.
    validate_re($path, '^/$|[^/]$')
  }

  if $path {
    $path_real = $homedir
  } elsif $name == 'root' {
    $path_real = $::osfamily ? {
      'Solaris' => '/',
      default   => '/root',
    }
  } else {
    $path_real = $::osfamily ? {
      'Solaris' => "/export/home/${name}",
      default   => "/home/${name}",
    }
  }

  if defined(File[$path_real]) {
    notify {"$fn File[$path_real] is already defined": }
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
  
    file { "$path_real":
      ensure => directory,
      owner  => $name,
      group  => $group_real,
      mode   => $mode,
    }
    #fail("$fn File[$path_real] should be defined")
  }
  #ensure_resource('file', $name, {'ensure' => 'present'})
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
