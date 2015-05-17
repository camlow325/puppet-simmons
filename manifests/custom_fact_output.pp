class simmons::custom_fact_output ($studio) {
  exec { 'remove-custom-fact-output':
    command => "rm -f ${studio}/custom-fact-output",
  }
  ->
  file { 'custom-fact-output':
    path    => "${studio}/custom-fact-output",
    ensure  => present,
    content => $custom_fact_hostname,
  }
}
