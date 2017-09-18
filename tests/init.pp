$username = 'user01'

#user { $username:
#    ensure => present
#}

homedir{"$username": 
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
