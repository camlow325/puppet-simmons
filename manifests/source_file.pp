class simmons::source_file ($studio) {
  exec { 'change-source-file':
    # Change the contents of source-file to something random so it will
    # (hopefully) always be different than a previous version of this file,
    # which will cause it to always be backed up to the server.
    # I think $RANDOM may not always be defined, so a timestamp is also
    # thrown in there so we don't end up with an empty file.
    # NOTE: previous implementations of this used `dd` but it sometimes
    # produced a file that causes an agent error during backup. See PUP-3377.
    # Keep a copy of the old (previous) version of the file around so we can
    # use it to verify filebucket backups are working as expected during
    # acceptance testing.
    command => "/bin/bash -c '/bin/echo \${RANDOM} \$(date) > ${studio}/source-file' &&
                /bin/cp -f ${studio}/source-file ${studio}/source-file-old",
  }
  ->
  file { 'source-file':
    path   => "${studio}/source-file",
    ensure => present,
    source => 'puppet:///modules/simmons/source-file',
    backup => 'server-backups',
  }
}
