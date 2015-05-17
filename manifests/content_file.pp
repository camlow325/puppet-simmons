class simmons::content_file ($studio) {
  exec { 'remove-content-file':
    command => "rm -f ${studio}/content-file",
  }
  ->
  file { 'content-file':
    path    => "${studio}/content-file",
    ensure  => present,
    content => "Static content defined in manifest\n",
  }
}
