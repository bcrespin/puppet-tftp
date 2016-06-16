# == Class: tftp
#
# This class installs and configures a TFTP server
#
# === Parameters
#
# $root:: Configures the root directory for the TFTP server
# $tfp_flags:: allow to pass addiotional arguments to daemon
# $package:: name of the tftp package
# $syslinux_package:: name of the syslinux package, essential for pxe boot
#
# === Usage
#
# * Simple usage:
#
#     include tftp
#
# * Configure a TFTP server with a non-default root directory:
#
#  class { 'tftp':
#    root => '/tftpboot',
#  }
#
# * Configure a TFTP server with non-default package name:
#  class { 'tftp:'
#    package => 'tftp-hpa-destruct',
#  }
class tftp (
  $root             = $tftp::params::root,
  $tfp_flags        = $tftp::params::tfp_flags,
  $package          = $tftp::params::package,
  $syslinux_package = $tftp::params::syslinux_package,
) inherits tftp::params {

  validate_absolute_path($root)

  class {'::tftp::install':} ->
  class {'::tftp::config':} ~>
  class {'::tftp::service':} ->
  Class['::tftp']
}
