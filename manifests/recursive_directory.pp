class simmons::recursive_directory ($studio) {
  exec { 'remove-recursive-directory':
    command => "rm -rf ${studio}/recursive-directory",
  }
  ->
  file { 'recursive-directory':
    ensure  => directory,
    path    => "${studio}/recursive-directory",
    source  => 'puppet:///modules/simmons/source-recursive-directory',
    recurse => true,
  }
}
