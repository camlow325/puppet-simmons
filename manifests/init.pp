class simmons::content_file ($studio) {
  exec { 'remove-content-file':
    command => "/bin/rm -f ${studio}/content-file",
  }
  ->
  file { 'content-file':
    path    => "${studio}/content-file",
    ensure  => present,
    content => "Static content defined in manifest\n",
  }
}

class simmons::mount_point_source_file ($studio) {
  exec { 'remove-mount-point-source-file':
    command => "/bin/rm -f ${studio}/mount-point-source-file",
  }
  ->
  file { 'mount-point-source-file':
    path   => "${studio}/mount-point-source-file",
    ensure => present,
    source => 'puppet:///simmons_custom_mount_point/mount-point-source-file',
  }
}

class simmons::mount_point_binary_file ($studio) {
  exec { 'remove-mount-point-binary-file':
    command => "/bin/rm -f ${studio}/mount-point-binary-file",
  }
  ->
  file { 'mount-point-binary-file':
    path   => "${studio}/mount-point-binary-file",
    ensure => present,
    mode   => "0755",
    source => 'puppet:///simmons_custom_mount_point/mount-point-binary-file',
  }
}

class simmons::recursive_directory ($studio) {
  exec { 'remove-recursive-directory':
    command => "/bin/rm -rf ${studio}/recursive-directory",
  }
  ->
  file { 'recursive-directory':
    path    => "${studio}/recursive-directory",
    source  => 'puppet:///modules/simmons/source-recursive-directory',
    ensure  => directory,
    recurse => true,
  }
}

class simmons::custom_fact_output ($studio) {
  exec { 'remove-custom-fact-output':
    command => "/bin/rm -f ${studio}/custom-fact-output",
  }
  ->
  file { 'custom-fact-output':
    path    => "${studio}/custom-fact-output",
    ensure  => present,
    content => $custom_fact_hostname,
  }
}

class simmons::external_fact_output ($studio) {
  exec { 'remove-external-fact-output':
    command => "/bin/rm -f ${studio}/external-fact-output",
  }
  ->
  file { 'external-fact-output':
    path    => "${studio}/external-fact-output",
    ensure  => present,
    content => $external_fact_hostname,
  }
}

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

class simmons (
  $studio    = undef,
  $exercises = ['simmons::content_file',
                'simmons::source_file',
                'simmons::binary_file',
                'simmons::recursive_directory',
                'simmons::mount_point_source_file',
                'simmons::mount_point_binary_file',
                'simmons::custom_fact_output',
                'simmons::external_fact_output'])
{
  validate_absolute_path($studio)
  validate_array($exercises)

  filebucket { 'server-backups':
    # use central filebucket on the server
    path => false,
  }

  file { $studio:
    ensure => directory,
  }
  ->
  notify { 'announce-exercises':
    message => join(flatten(['Todays Exercises:', $exercises]), "\n"),
  }
  ->
  class { $exercises:
    studio => $studio,
  }
}
