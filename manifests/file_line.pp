define homedir::file_line(
    $user = $::id,
    $homedir_path = undef,
    $rel_path = undef,
    $group = undef,
    $mode  = undef,
    $ensure = 'present',
    $source = undef,
    $content = undef,
    $require = undef,
    
    $line_name = undef,
    $line_ensure       = undef,
    $line              = undef,
    $match             = undef,
    $match_for_absence = undef,
    $line_encoding     = undef,

) {
  $fn = "virtualenvwrapper::homedir_file"

  #if defined(Homedir::File[$user]) {
  #  notify {"$fn Homedir::File[$user] is already defined": }
  #} else {
    homedir::file {"$user:~/$rel_path":
      user => $user,
      homedir_path => $homedir_path,
      rel_path => $rel_path,
      group => $group,
      mode => $mode,
      ensure => $ensure,
      source => $source,
      content => $content,
      require => $require,
    }
  #}

  if $homedir_path {
    validate_re($homedir_path, '^/')
    # If the home directory is not / (root on solaris) then disallow trailing slashes.
    validate_re($homedir_path, '^/$|[^/]$')
  }

  if $homedir_path {
    $homedir_path_real = $homedir_path
  } elsif $user == 'root' {
    $homedir_path_real = $::osfamily ? {
      'Solaris' => '/',
      default   => '/root',
    }
  } else {
    $homedir_path_real = $::osfamily ? {
      'Solaris' => "/export/home/${user}",
      default   => "/home/${user}",
    }
  }
  #notify {"$fn homedir_path_real: $homedir_path_real": }


  if $rel_path {
    #validate_re($rel_path, '^/')
    # If the home directory is not / (root on solaris) then disallow trailing slashes.
    validate_re($rel_path, '^[^/]')
  } else {
    fail("$fn rel_path is not set")
  }

  $path = "$homedir_path_real/$rel_path"
  notify {"$fn path: $path": }

  if defined(File_Line[$path]) {
    notify {"$fn File_Line[$path] is already defined": }
  } else {
    if $line_name {
      $line_name_real = $line_name
    } else {
      $line_name_real = "line $line in $path of user $user"
    }
    file_line { "$line_name_real":
      ensure => $line_ensure,
      path   => $path,
      line   => $line,
      match  => $match,
      match_for_absence => $match_for_absence,
    }
    #fail("$fn File[$path_real] should be defined")
  }
  
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
