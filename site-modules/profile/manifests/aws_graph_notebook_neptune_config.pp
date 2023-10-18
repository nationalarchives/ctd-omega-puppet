class profile::aws_graph_notebook_neptune_config (String $user = 'ec2-user') {
  file { "/home/${user}/graph_notebook_config.json":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0740',
    content => '{
  "host": "dev-neptune-cluster-a.cluster-chp1fpphk1ab.eu-west-2.neptune.amazonaws.com",
  "port": 8182,
  "auth_mode": "IAM",
  "load_from_s3_arn": "",
  "ssl": true,
  "ssl_verify": true,
  "aws_region": "eu-west-2"
}',
  }
}
