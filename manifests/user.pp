define homedir::user(
) {
  $fn = "homedir::user"

  if defined(User[$name]) {
    notify {"$fn User[$name] resource is already defined": }
  } else {
    user {"$name":
      ensure => present,
    }
    #fail("$fn User[$name] resource should be defined")
  }
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
