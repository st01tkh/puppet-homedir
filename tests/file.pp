$username = 'user01'

#user { $username:
#    ensure => present
#}

homedir::file{"$username": 
    rel_path => 'TestFile',
    content => "Test file content",
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
