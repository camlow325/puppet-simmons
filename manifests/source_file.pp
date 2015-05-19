class simmons::source_file ($studio) {
  file { 'source-file-old':
    ensure  => present,
    path    => "${studio}/source-file-old",
    content => rand_text(),
  }
  ->
  exec { 'change-source-file':
    # Change the contents of source-file to something random so it will
    # (hopefully) always be different than a previous version of this file,
    # which will cause it to always be backed up to the server.
    # NOTE: previous implementations of this used `dd` but it sometimes
    # produced a file that causes an agent error during backup. See PUP-3377.
    # Keep a copy of the old (previous) version of the file around so we can
    # use it to verify filebucket backups are working as expected during
    # acceptance testing.
    command => "cp -f ${studio}/source-file-old ${studio}/source-file",
  }
  ->
  file { 'source-file':
    ensure => present,
    path   => "${studio}/source-file",
    source => 'puppet:///modules/simmons/source-file',
    backup => 'server-backups',
  }
}
