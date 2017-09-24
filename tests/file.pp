$username = 'user01'

#user { $username:
#    ensure => present
#}

homedir::file{"$username:~/TestFile":
    user => "$username",
    rel_path => 'TestFile',
    content => "Test file content",
}

homedir::file{"$username:~/TestFile2": 
    user => "$username",
    rel_path => 'TestFile2',
    content => "Test file content2",
}

homedir::file{"$username:~/pup-mod link to puppet modules": 
    ensure => link,
    user => "$username",
    rel_path => 'pup-modules',
    target => '/opt/puppetlabs/puppet/modules',
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
