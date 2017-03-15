Package {
  allow_virtual => false,
}
package { 'git':
  ensure => present,
}
file { '/apps/solr':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
} ->
file { '/apps/solr/solr':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
} ->
file { '/apps/solr/solr/cores':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
}
file { '/apps/ca':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
}
firewall { '100 allow HTTP and HTTPS access to Solr':
  dport => [8983, 8984],
  proto => tcp,
  action => accept,
}
