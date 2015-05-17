class simmons::mount_point_source_file ($studio) {
  exec { 'remove-mount-point-source-file':
    command => "rm -f ${studio}/mount-point-source-file",
  }
  ->
  file { 'mount-point-source-file':
    path   => "${studio}/mount-point-source-file",
    ensure => present,
    source => 'puppet:///simmons_custom_mount_point/mount-point-source-file',
  }
}
