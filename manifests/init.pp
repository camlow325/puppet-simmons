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

  exec { 'change-binary-file':
    command => "cp -f /usr/bin/who ${studio}/binary-file",
  }

  exec { 'change-source-file':
    command => "bash -c 'dd if=/dev/urandom bs=512 count=1 > ${studio}/source-file'",
  }

  exec { 'remove-custom-fact-output':
    command => "rm -f ${studio}/custom-fact-output",
  }

  exec { 'remove-external-fact-output':
    command => "rm -f ${studio}/external-fact-output",
  }
}

class simmons::exercise ($studio) {

  filebucket { 'backups':
    # use central filebucket on the server
    path => false,
  }

  # TEST files are backed up on master
  File {
    backup => backups,
  }

  # TEST contents = "Static content defined in manifest"
  file { 'content-file':
    path    => "${studio}/content-file",
    ensure  => present,
    content => "Static content defined in manifest\n",
  }

  # TEST contents = "Static source file contents"
  file { 'source-file':
    path   => "${studio}/source-file",
    ensure => present,
    source => 'puppet:///modules/simmons/source-file',
  }

  # TODO how do we test this?
  file { 'binary-file':
    path   => "${studio}/binary-file",
    ensure => present,
    mode   => "0755",
    source => 'puppet:///modules/simmons/binary-file',
  }

  # TEST directory exists
  # TEST subdirectory exists
  # TEST subdirectory/subfile contents = "Recursive subfile contents"
  file { 'recursive-directory':
    path    => "${studio}/recursive-directory",
    source  => 'puppet:///modules/simmons/source-recursive-directory',
    ensure  => directory,
    recurse => true,
  }

  # TEST contents = "File served from custom mount point"
  file { 'mount-point-source-file':
    path   => "${studio}/mount-point-source-file",
    ensure => present,
    source => 'puppet:///simmons_custom_mount_point/mount-point-source-file',
  }

  # TODO how do we test this?
  file { 'mount-point-binary-file':
    path   => "${studio}/mount-point-binary-file",
    ensure => present,
    mode   => "0755",
    source => 'puppet:///simmons_custom_mount_point/mount-point-binary-file',
  }

  # TEST contents = <hostname>
  file { 'custom-fact-output':
    path    => "${studio}/custom-fact-output",
    ensure  => present,
    content => $custom_fact_hostname,
  }

  # TEST contents = <hostname>
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
