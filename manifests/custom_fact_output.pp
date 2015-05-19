class simmons::custom_fact_output ($studio) {
  exec { 'remove-custom-fact-output':
    command => "rm -f ${studio}/custom-fact-output",
  }
  ->
  file { 'custom-fact-output':
    ensure  => present,
    path    => "${studio}/custom-fact-output",
    content => $::custom_fact_hostname,
  }
}
