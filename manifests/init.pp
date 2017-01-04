# This class supports the Global File System.  It ensures that the
# appropriate files are in the appropriate places and that the necessary
# packages and services are present.
#
# This module is incompatible with the acpid module.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class gfs2 {
  include '::network'

  file { '/etc/cluster':
    ensure => 'directory',
    mode   => '0750',
    owner  => 'root',
    group  => 'root'
  }

  iptables_rule { 'allow_anycast_multicast':
    order   => 5,
    content => '-s 224.0.0.1 -m addrtype --src-type MULTICAST -j ACCEPT',
    require => Package['ricci']
  }

  package { 'ricci':
    ensure => 'latest'
  }

  # For the SCSI Fence
  package { 'sg3_utils': ensure => 'latest' }

  if $facts['virtual'] and ( ( $facts['virtual'] == 'xenu' ) or ( $facts['virtual'] == 'xen0' ) ) {
    package { [
      'kmod-gnbd-xen',
      "libvirt.${facts['hardwaremodel']}" ]:
        ensure => 'latest'
    }
  }

  package { [
    'modcluster',
    'rgmanager',
    'gfs2-utils',
    'lvm2-cluster',
    'cman' ]:
      ensure => 'latest'
  }

  service { 'acpid':
    ensure => 'stopped',
    enable => false,
    before => Service['gfs2']
  }

  service { 'cman':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['modcluster'],
      Package['cman'],
      Package['ricci']
    ]
  }

  service { 'rgmanager':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['rgmanager'],
      Service['cman'],
      Package['ricci']
    ]
  }

  service { 'gfs2':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['gfs2-utils'],
      Service['rgmanager'],
      Package['ricci']
    ]
  }

  service { 'clvmd':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
        Package['lvm2-cluster'],
        Service['rgmanager'],
        Package['ricci']
    ]
  }

  service { 'ricci':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['ricci']
  }
}
