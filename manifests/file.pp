define homedir::file(
    # local parameters
    $user = $::id,
    $homedir_path = undef,
    $rel_path = undef,
    
    # file resource parameters
    $path = undef,
    $ensure = undef,
    $backup = undef,
    $checksum = undef,
    $checksum_value = undef,
    $content = undef, 
    $ctime = undef,
    $force = undef,
    $group = undef,
    $ignore = undef,
    $links = undef,
    $mode = undef,
    $mtime = undef,
    $owner = undef,
    $provider = undef,
    $purge = undef,
    $recurse = undef, 
    $recurselimit = undef,
    $replace = undef,
    $selinux_ignore_defaults = undef,
    $selrange = undef,
    $selrole = undef,
    $seltype = undef,
    $seluser = undef,
    $show_diff = undef,
    $source = undef,
    $source_permissions = undef,
    $sourceselect = undef,
    $target = undef,
    $type = undef,
    $validate_cmd = undef,
    $validate_replacement = undef,

    # meteparameters
    $alias = undef,
    $audit = undef,
    $before = undef,
    $consume = undef,
    $export = undef,
    $loglevel = undef,
    $noop = undef,
    $notify = undef,
    $require = undef,
    $schedule = undef,
    $stage = undef,
    $subscribe = undef,
    $tag = undef
) {
  $fn = "homedir::file"

  if !defined(Homedir[$user]) {
    homedir {"$user":
      path => $homedir_path,
    }
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
    validate_re($rel_path, '^[^/]')
  } else {
    fail("$fn rel_path is not set")
  }

  $path_real = "$homedir_path_real/$rel_path"

  if !defined(File[$path_real]) {
    if $group {
      $group_real = $group
    } else {
      $group_real = $user
    }

    if !defined(Group[$group_real]) {
      group { "$group_real":
        ensure => present,
      }
    }

    if $owner {
      $owner_real = $owner
    } else {
      $owner_real = $user
    }

    file { "homedir::file for $user:~/$rel_path":
      # changed file resource parameters
      path => $path_real,
      owner => $owner_real,
      group => $group_real,
      
      # forwarded file resource parameters
      ensure => $ensure,
      backup => $backup,
      checksum => $checksum,
      checksum_value => $checksum_value,
      content => $content,
      ctime => $ctime,
      force => $force,
      ignore => $ignore,
      links => $links,
      mode => $mode,
      mtime => $mtime,
      provider => $provider,
      purge => $purge,
      recurse => $recurse,
      recurselimit => $recurselimit,
      replace => $replace,
      selinux_ignore_defaults => $selinux_ignore_defaults,
      selrange => $selrange,
      selrole => $selrole,
      seltype => $seltype,
      seluser => $seluser,
      show_diff => $show_diff,
      source => $source,
      source_permissions => $source_permissions,
      sourceselect => $sourceselect,
      target => $target,
      type => $type,
      validate_cmd => $validate_cmd,
      validate_replacement => $validate_replacement,
      
      # forwarded meteparameters
      alias => $alias,
      audit => $audit,
      before => $before,
      consume => $consume,
      export => $export,
      loglevel => $loglevel,
      noop => $noop,
      notify => $notify,
      require => $require,
      schedule => $schedule,
      stage => $stage,
      subscribe => $subscribe,
      tag => $tag,
    }
  }
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
