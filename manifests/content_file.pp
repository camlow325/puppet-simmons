class simmons::content_file ($studio) {
  exec { 'remove-content-file':
    command => "rm -f ${studio}/content-file",
  }
  ->
  file { 'content-file':
    ensure  => present,
    path    => "${studio}/content-file",
    content => "Static content defined in manifest\n",
  }
}
