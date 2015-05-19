class simmons::external_fact_output ($studio) {
  exec { 'remove-external-fact-output':
    command => "rm -f ${studio}/external-fact-output",
  }
  ->
  file { 'external-fact-output':
    ensure  => present,
    path    => "${studio}/external-fact-output",
    content => $::external_fact_hostname,
  }
}
