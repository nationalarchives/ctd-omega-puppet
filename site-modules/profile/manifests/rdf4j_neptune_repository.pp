class profile::rdf4j_neptune_repository (String $appdata_basedir = '/home/tomcat/.RDF4J') {
  include profile::rdf4j
  include profile::tomcat

  file { $appdata_basedir:
    ensure  => directory,
    owner   => 'tomcat',
    group   => 'tomcat',
    require => User['tomcat'],
  }

  file { "${appdata_basedir}/server":
    ensure  => directory,
    owner   => 'tomcat',
    group   => 'tomcat',
    require => File[$appdata_basedir],
  }

  file { "${appdata_basedir}/server/repositories":
    ensure  => directory,
    owner   => 'tomcat',
    group   => 'tomcat',
    require => File["${appdata_basedir}/server"],
  }

  file { "${appdata_basedir}/server/repositories/neptune":
    ensure  => directory,
    owner   => 'tomcat',
    group   => 'tomcat',
    require => File["${appdata_basedir}/server/repositories"],
  }

  file { "${appdata_basedir}/server/repositories/neptune/config.ttl":
    ensure  => file,
    replace => false,
    owner   => 'tomcat',
    group   => 'tomcat',
    content => '@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix rep: <http://www.openrdf.org/config/repository#> .
@prefix sparql: <http://www.openrdf.org/config/repository/sparql#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<#neptune> a rep:Repository;
  rep:repositoryID "neptune";
  rep:repositoryImpl [
      rep:repositoryType "openrdf:SPARQLRepository";
      sparql:query-endpoint <https://dev-neptune-cluster-a.cluster-chp1fpphk1ab.eu-west-2.neptune.amazonaws.com:8182/sparql>;
      sparql:update-endpoint <https://dev-neptune-cluster-a.cluster-chp1fpphk1ab.eu-west-2.neptune.amazonaws.com:8182/sparql>
    ];
  rdfs:label "Neptune DB instance" .
',
    require => File["${appdata_basedir}/server/repositories/neptune"],
  }
}
