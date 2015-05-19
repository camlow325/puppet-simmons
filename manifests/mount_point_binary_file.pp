class simmons::mount_point_binary_file ($studio) {
  exec { 'remove-mount-point-binary-file':
    command => "rm -f ${studio}/mount-point-binary-file",
  }
  ->
  file { 'mount-point-binary-file':
    ensure => present,
    path   => "${studio}/mount-point-binary-file",
    mode   => '0755',
    source => 'puppet:///simmons_custom_mount_point/mount-point-binary-file',
  }
}
