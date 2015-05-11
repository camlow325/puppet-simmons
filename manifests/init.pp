class simmons::warmup ($studio) {

  Exec {
    path => '/bin',
  }

  exec { 'remove-content-file':
    command => "rm -f ${studio}/content-file",
  }

  exec { 'remove-mount-point-source-file':
    command => "rm -f ${studio}/mount-point-source-file",
  }

  exec { 'remove-mount-point-binary-file':
    command => "rm -f ${studio}/mount-point-binary-file",
  }

  exec { 'remove-recursive-directory':
    command => "rm -rf ${studio}/recursive-directory",
  }

  exec { 'remove-custom-fact-output':
    command => "rm -f ${studio}/custom-fact-output",
  }

  exec { 'remove-external-fact-output':
    command => "rm -f ${studio}/external-fact-output",
  }

  exec { 'change-binary-file':
    # Change the contents of the file so it will be backed up to the server.
    command => "cp -f /usr/bin/who ${studio}/binary-file &&
                cp -f ${studio}/binary-file ${studio}/binary-file-old",
  }

  exec { 'change-source-file':
    # Change the contents of source-file to something random so it will
    # (hopefully) always be different than a previous version of this file,
    # which will cause it to always be backed up to the server.
    # I think $RANDOM may not always be defined, so a timestamp is also
    # thrown in there so we don't end up with an empty file.
    # NOTE: previous implementations of this used `dd` but it sometimes
    # produced a file that causes an agent error during backup. See PUP-3377.
    command => "bash -c 'echo \${RANDOM} \$(date) > ${studio}/source-file' &&
                cp -f ${studio}/source-file ${studio}/source-file-old",
  }
}

class simmons::exercise ($studio) {

  filebucket { 'backups':
    # use central filebucket on the server
    path => false,
  }

  file { 'source-file':
    path   => "${studio}/source-file",
    ensure => present,
    source => 'puppet:///modules/simmons/source-file',
    backup => backups,
  }

  file { 'binary-file':
    path   => "${studio}/binary-file",
    ensure => present,
    mode   => "0755",
    source => 'puppet:///modules/simmons/binary-file',
    backup => backups,
  }

  file { 'content-file':
    path    => "${studio}/content-file",
    ensure  => present,
    content => "Static content defined in manifest\n",
  }

  file { 'recursive-directory':
    path    => "${studio}/recursive-directory",
    source  => 'puppet:///modules/simmons/source-recursive-directory',
    ensure  => directory,
    recurse => true,
  }

  file { 'mount-point-source-file':
    path   => "${studio}/mount-point-source-file",
    ensure => present,
    source => 'puppet:///simmons_custom_mount_point/mount-point-source-file',
  }

  file { 'mount-point-binary-file':
    path   => "${studio}/mount-point-binary-file",
    ensure => present,
    mode   => "0755",
    source => 'puppet:///simmons_custom_mount_point/mount-point-binary-file',
  }

  file { 'custom-fact-output':
    path    => "${studio}/custom-fact-output",
    ensure  => present,
    content => $custom_fact_hostname,
  }

  file { 'external-fact-output':
    path    => "${studio}/external-fact-output",
    ensure  => present,
    content => $external_fact_hostname,
  }
}

class simmons ($studio = undef) {
  $error = "\$studio directory string parameter required, got: $studio"
  validate_re($studio, '\D+', $error)

  file { 'studio-directory':
    path   => "${studio}",
    ensure => directory,
  }
  ->
  class { 'simmons::warmup':
    studio => $studio,
  }
  ->
  class { 'simmons::exercise':
    studio => $studio,
  }
}
