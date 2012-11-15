# Class: postgresql::server
#
# manages the installation of the postgresql server.  manages the package and service
#
# Parameters:
#   [*package_version*] - package version - currently supports 8.4 and 9.1 on RedHat systems
#   [*package_name*] - name of package
#   [*service_name*] - name of service
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::server (
  $package_version    = $postgresql::params::package_version,
  $package_name       = $postgresql::params::server_package_name,
  $devel_package_name = $postgresql::params::devel_package_name,
  $package_ensure     = 'present',
  $service_name       = $postgresql::params::service_name,
  $service_provider   = $postgresql::params::service_provider,
  $service_status     = $postgresql::params::service_status,
  $config_hash        = {}
) inherits postgresql::params {

  package { 'postgresql-server':
    ensure => $package_ensure,
    name   => $package_name,
  }

  package { 'postgresql-devel':
    ensure => $package_ensure,
    name   => $devel_package_name,
  }

  $config_class = {}
  $config_class['postgresql::config'] = $config_hash

  create_resources( 'class', $config_class )

  Package['postgresql-server'] -> Class['postgresql::config']

  if ($needs_initdb) {
    include postgresql::initdb

    Class['postgresql::initdb'] -> Class['postgresql::config']
    Class['postgresql::initdb'] -> Service['postgresqld']
  }

  service { 'postgresqld':
    ensure   => running,
    name     => $service_name,
    enable   => true,
    require  => Package['postgresql-server'],
    provider => $service_provider,
    status   => $service_status,
  }

  exec {'reload_postgresql':
    refreshonly => true,
    command => "/sbin/service ${postgresql::params::service_name} reload",
  }
}
