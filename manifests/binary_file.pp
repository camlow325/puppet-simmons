class simmons::binary_file ($studio) {
  file { 'binary-file-old':
    path   => "${studio}/binary-file-old",
    ensure => present,
    mode   => "0644",
    source => 'puppet:///modules/simmons/binary-file-old',
  }
  ->
  exec { 'change-binary-file':
    # Change the contents of the file so it will be backed up to the server.
    # Keep a copy of the old (previous) version of the file around so we can
    # use it to verify filebucket backups are working as expected during
    # acceptance testing.
    command => "cp -f ${studio}/binary-file-old ${studio}/binary-file",
  }
  ->
  file { 'binary-file':
    path   => "${studio}/binary-file",
    ensure => present,
    mode   => "0755",
    source => 'puppet:///modules/simmons/binary-file',
    backup => 'server-backups',
  }
}
