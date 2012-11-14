# Class: postgresql
#
#   This class installs postgresql client software.
#
# Parameters:
#   [*package_version*]      - Postgres version - currently supports 8.4 and 9.1 for RedHat systems
#   [*client_package_name*]  - The name of the postgresql client package.
#   [*devel_package_name*]   - The name of the postgresql development package.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql (
  $package_version    = $postgresql::params::package_version,
  $package_name       = $postgresql::params::client_package_name,
  $devel_package_name = $postgresql::params::devel_package_name,
  $package_ensure     = 'present'
) inherits postgresql::params {

  Class['postgresql'] -> Class['postgresql::repo']

  include postgresql::repo

  package { 'postgresql_client':
    name   => $package_name,
    ensure => $package_ensure,
  }

  if ! defined(Package['postgresql-devel']) {
    package { 'postgresql-devel':
      name   => $devel_package_name,
      ensure => $package_ensure,
    }
  }
}
