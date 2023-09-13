class profile::omega_code_repositories {
  # TODO(AR) move this data to Hiera! and make sure we have them all listed
  $repos = [
    # Infrastructure
    {
      'path'     => '/home/ec2-user/code/ctd-omega-puppet',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-puppet.git',
      },
      'revision' => 'env/production'
    },
    {
      'path'     => '/home/ec2-user/code/ctd-omega-infrastructure',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-infrastructure.git',
      },
      'revision' => 'main',
      'clone'    => false,  # TODO(AR) currently a private repo, remove this when it becomes public repo
    },

    # jms4s libraries
    {
      'path'     => '/home/ec2-user/code/jms4s',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/jms4s.git',
      },
      'revision' => 'main'
    },
    {
      'path'     => '/home/ec2-user/code/jms4s-request-reply',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/jms4s-request-reply.git',
      },
      'revision' => 'main'
    },
    {
      'path'     => '/home/ec2-user/code/jms4s-request-reply-stub',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/jms4s-request-reply-stub.git',
      },
      'revision' => 'main'
    },

    # Editorial front-end application
    {
      'path'     => '/home/ec2-user/code/ctd-omega-editorial-frontend',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-editorial-frontend.git',
      },
      'revision' => 'main'
    },
    {
      'path'     => '/home/ec2-user/code/ctd-omega-editorial-prototype',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-editorial-prototype.git',
      },
      'revision' => 'main'
    },

    # Services application
    {
      'path'     => '/home/ec2-user/code/ctd-omega-services',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-services.git',
      },
      'revision' => 'main'
    },
    {
      'path'     => '/home/ec2-user/code/ctd-omega-services-prototype',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-services-prototype.git',
      },
      'revision' => 'main',
      'clone'    => false,  # TODO(AR) currently a private repo, remove this when it becomes public repo
    },
    {
      'path'     => '/home/ec2-user/code/ctd-omega-client-stub',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-client-stub.git',
      },
      'revision' => 'main',
      'clone'    => false,  # TODO(AR) currently a private repo, remove this when it becomes public repo
    },
    {
      'path'     => '/home/ec2-user/code/ctd-omega-rdf2json4es',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-rdf2json4es.git',
      },
      'revision' => 'main',
      'clone'    => false,  # TODO(AR) currently a private repo, remove this when it becomes public repo
    },

    # OCI Tools
    {
      'path'     => '/home/ec2-user/code/oci-tools-scala',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/oci-tools-scala.git',
      },
      'revision' => 'main'
    },
    {
      'path'     => '/home/ec2-user/code/oci-tools-ts',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/oci-tools-ts.git',
      },
      'revision' => 'main'
    },

    # ETL Repositories
    {
      'path'     => '/home/ec2-user/code/pentaho-kettle',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/pentaho-kettle.git',
        'upstream' => 'https://github.com/pentaho/pentaho-kettle',
      },
      'revision' => '9.1-TNA'
    },
    {
      'path'     => '/home/ec2-user/code/pentaho-platform',
      'source'   => {
        'origin' => 'https://github.com/pentaho/pentaho-platform.git',
      },
      'revision' => '9.1.0.0'
    },
    {
      'path'     => '/home/ec2-user/code/kettle-jena-plugins',
      'source'   => {
        'origin' => 'https://github.com/nationalarchives/kettle-jena-plugins.git',
      },
      'revision' => 'main',
    },
    {
      'path'     => '/home/ec2-user/code/kettle-atomic-plugins',
      'source'   => {
        'origin' => 'https://github.com/nationalarchives/kettle-atomic-plugins.git',
      },
      'revision' => 'main',
    },
    {
      'path'     => '/home/ec2-user/code/kettle-debug-plugins',
      'source'   => {
        'origin' => 'https://github.com/evolvedbinary/kettle-debug-plugins.git',
      },
      'revision' => 'main',
    },
    {
      'path'     => '/home/ec2-user/code/kettle-xml-extra-plugins',
      'source'   => {
        'origin' => 'https://github.com/nationalarchives/kettle-xml-extra-plugins.git',
      },
      'revision' => 'main',
    },
    {
      'path'     => '/home/ec2-user/code/kettle-test-framework',
      'source'   => {
        'origin' => 'https://github.com/nationalarchives/kettle-test-framework.git',
      },
      'revision' => 'main',
    },
    {
      'path'     => '/home/ec2-user/code/tna-cat',
      'source'   => {
        'origin' => 'https://github.com/nationalarchives/tna-cat.git',
      },
      'revision' => 'main',
      'clone'    => false, # TODO(AR) currently a private repo, remove this when it becomes public repo
    },
    {
      'path'     => '/home/ec2-user/code/ctd-omega-etl-workflows',
      'source'   => {
        'origin' => 'https://github.com/nationalarchives/ctd-omega-etl-workflows.git',
      },
      'revision' => 'main',
      'clone'    => false,  # TODO(AR) currently a private repo, remove this when it becomes public repo
    },

    # Technical Tests for interviewing potential Omega developers
    {
      'path'     => '/home/ec2-user/code/ctd-omega-interview-tech-test-java ',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-interview-tech-test-java .git',
      },
      'revision' => 'main',
      'clone'    => false,  # TODO(AR) currently a private repo, remove this when it becomes public repo
    },
    {
      'path'     => '/home/ec2-user/code/ctd-omega-interview-tech-test-scala ',
      'source'   => {
        'origin'   => 'https://github.com/nationalarchives/ctd-omega-interview-tech-test-scala .git',
      },
      'revision' => 'main',
      'clone'    => false,  # TODO(AR) currently a private repo, remove this when it becomes public repo
    },
  ]

  $repos.each |$repo| {
    if $repo["clone"] == false {
      vcsrepo { $repo["path"]:
        ensure             => present,
        provider           => git,
        owner              => 'ec2-user',
        group              => 'ec2-user',
        require            => [
          Package['git']
        ],
      }
      $repo["source"].each |$key,$value| {
        exec { "init_${repo['path']}":
          command   => "git remote add ${key} ${value}",
          path      => '/usr/bin',
          cwd       => $repo["path"],
          user      => 'ec2-user',
          group     => 'ec2-user',
          subscribe => [
            Vcsrepo[$repo["path"]]
          ],
        }
      }
    } else {
      file { $repo["path"]:
        ensure  => directory,
        replace => false,
        owner   => 'ec2-user',
        group   => 'ec2-user',
        require => File['/home/ec2-user/code'],
      }
      vcsrepo { $repo["path"]:
        ensure             => latest,
        provider           => git,
        source             => $repo["source"],
        revision           => $repo["revision"],
        keep_local_changes => true,
        owner              => 'ec2-user',
        group              => 'ec2-user',
        require            => [
          Package['git'],
          File[$repo["file"]]
        ],
      }
    } end
  }

  # NOTE: Required for Pentaho Kettle
  package { 'system-lsb-core':
    ensure  => installed,
    require => File['/home/ec2-user/code/pentaho-kettle'],
  }
}
