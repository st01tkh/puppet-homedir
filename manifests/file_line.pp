define homedir::file_line(
  # local parameters
  $user = $::id,
  $homedir_path = undef,
  $rel_path = undef,

  # changed file resource parameters
  $file_name = undef,

  # forwarded file resource parameters
  $ensure = 'present',
  $group = undef,
  $mode  = undef,
  $source = undef,
  $content = undef,

  # changed file_line resource parameters
  $line_name = undef,
  $line_ensure       = undef,

  # forwarded file_line resource parameters
  $after = undef,
  $encoding = undef,
  $line              = undef,
  $match             = undef,
  $match_for_absence = undef,
  $multiple          = undef,
  $replace           = undef,

  # meteparameters
) {
  $fn = "virtualenvwrapper::homedir_file"

  if $file_name {
    $file_name_real = $file_name
  } else {
    $file_name_real = "$name $user:~/$rel_path"
  }

  if !defined(Homedir::File[$file_name_real]) {
    homedir::file {"$file_name_real":
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
  }

  if $homedir_path {
    validate_re($homedir_path, '^/')
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

  if $rel_path {
    validate_re($rel_path, '^[^/]')
  } else {
    fail("$fn rel_path is not set")
  }

  $path_real = "$homedir_path_real/$rel_path"

  if !defined(File_Line[$path_real]) {
    if $line_name {
      $line_name_real = $line_name
    } else {
      $line_name_real = "line $line in $path_real of user $user"
    }

    file_line { "$line_name_real":
      # changed file_line resource parameters
      ensure => $line_ensure,

      # forwarded file_line resource parameters
      after => $after,
      encoding => $encoding,
      path   => $path_real,
      line => $line,          
      match => $match,
      match_for_absence => $match_for_absence,
      multiple => $multiple,
      replace => $replace,
    }
  }
  
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
