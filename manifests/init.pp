class simmons (
  $studio    = undef,
  $exercises = ['simmons::content_file',
                'simmons::source_file',
                'simmons::binary_file',
                'simmons::recursive_directory',
                'simmons::mount_point_source_file',
                'simmons::mount_point_binary_file',
                'simmons::custom_fact_output',
                'simmons::external_fact_output'],
) {
  validate_absolute_path($studio)
  validate_array($exercises)

  Exec {
    path => $::path
  }

  filebucket { 'server-backups':
    # use central filebucket on the server
    path => false,
  }

  file { $studio:
    ensure => directory,
  }
  ->
  notify { 'announce-exercises':
    message => join(flatten(['Todays Exercises:', $exercises]), "\n"),
  }
  ->
  class { $exercises:
    studio => $studio,
  }
}
