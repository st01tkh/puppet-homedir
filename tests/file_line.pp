$username = 'user01'

#user { $username:
#    ensure => present
#}

homedir::file_line{"$username": 
    content => 'Some content',
    rel_path => 'TestFile',
    line_ensure => 'present',
    line => 'AAAA'
}
