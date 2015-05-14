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
