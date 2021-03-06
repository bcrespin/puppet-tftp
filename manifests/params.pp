# TFTP defaults
class tftp::params {
  case $::osfamily {
    'Debian': {
      $package    = 'tftpd-hpa'
      $daemon     = true
      $service    = 'tftpd-hpa'
      $tftp_flags = undef
      if $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '16.04') >= 0 {
        # 16.04's Puppet package defaults to upstart (https://bugs.launchpad.net/ubuntu/+source/puppet/+bug/1570472)
        $service_provider = 'systemd'
      } else {
        $service_provider = undef
      }
      if $::operatingsystem == 'Ubuntu' {
        $root = '/var/lib/tftpboot'
      } else {
        $root = '/srv/tftp'
      }
      if  ($::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '14.10') >= 0) or
          ($::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '8') >= 0) {
        $syslinux_package = [ 'syslinux-common', 'pxelinux' ]
      } else {
        $syslinux_package = 'syslinux'
      }
    }
    'RedHat': {
      $package          = 'tftp-server'
      $daemon           = false
      $syslinux_package = 'syslinux'
      $tftp_flags       = undef
      if $::operatingsystemrelease =~ /^(4|5)/ {
        $root  = '/tftpboot'
      } else {
        $root  = '/var/lib/tftpboot'
      }
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          $package          = 'tftp-server'
          $daemon           = false
          $root             = '/var/lib/tftpboot'
          $tftp_flags       = undef
          $syslinux_package = 'syslinux'
        }
        default: {
          fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
        }
      }
    }
    /^(FreeBSD|DragonFly)$/: {
      $package          = 'tftp-hpa'
      $daemon           = true
      $service          = 'tftpd'
      $service_provider = undef
      $root             = '/tftpboot'
      $tftp_flags       = undef
      $syslinux_package = 'syslinux'
    }
    'Archlinux': {
      $package          = 'tftp-hpa'
      $daemon           = true
      $service          = 'tftpd.socket' #systemd starts the socket not the service
      $syslinux_package = 'syslinux'
      $root             = '/srv/tftp'
      $tftp_flags       = undef
    }


    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }
}
