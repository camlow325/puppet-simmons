class simmons::binary_file ($studio) {
  exec { 'change-binary-file':
    # Change the contents of the file so it will be backed up to the server.
    # Keep a copy of the old (previous) version of the file around so we can
    # use it to verify filebucket backups are working as expected during
    # acceptance testing.
    command => "/bin/cp -f /bin/ls ${studio}/binary-file &&
                /bin/cp -f ${studio}/binary-file ${studio}/binary-file-old",
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
