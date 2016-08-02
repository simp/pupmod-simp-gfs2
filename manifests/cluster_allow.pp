# == Class: gfs2::cluster_allow
#
# This function opens the following ports and connection types for the provided
# $cluster_nets.
#
#   Port Number(s)            Type   Use
#   1229                      UDP    fencing access
#   5404 5405                 UDP    cman access
#   11111                     TCP    ricci access
#   11111                     UDP    ricci access
#   14567                     TCP    gnbd access
#   16851                     TCP    modclusterd access
#   21064                     TCP    dlm access
#   41966 41967 41968 41969   TCP    rgmanager access
#   50006 50008 50009         TCP    ccsd access
#   50007                     UDP    ccsd access
#
# == Parameters
#
# [*cluster_nets*]
#   For the widest subnet accessibility, set $cluster_nets to
#   nets2cidr(hiera('client_nets')).
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class gfs2::cluster_allow (
  $cluster_nets
) {

  iptables::add_udp_listen { 'allow_cman':
    client_nets => $cluster_nets,
    dports      => ['5404','5405','6809']
  }

  # Conga
  iptables::add_tcp_stateful_listen { 'allow_ricci':
    client_nets => $cluster_nets,
    dports      => '11111'
  }

  iptables::add_udp_listen { 'allow_ricci':
    client_nets => $cluster_nets,
    dports      => '11111',
    require     => Service['ricci']
  }

  iptables::add_tcp_stateful_listen { 'allow_gnbd':
    client_nets => $cluster_nets,
    dports      => '14567'
  }

  iptables::add_tcp_stateful_listen { 'allow_modclusterd':
    client_nets => $cluster_nets,
    dports      => '16851'
  }

  iptables::add_tcp_stateful_listen { 'allow_dlm':
    client_nets => $cluster_nets,
    dports      => '21064'
  }

  iptables::add_tcp_stateful_listen { 'allow_ccsd':
    client_nets => $cluster_nets,
    dports      => [ '50006', '50008', '50009' ]
  }

  iptables::add_udp_listen { 'allow_ccsd':
    client_nets => $cluster_nets,
    dports      => '50007'
  }

  iptables::add_udp_listen { 'allow_fencing':
    client_nets => $cluster_nets,
    dports      => '1229'
  }

  iptables_rule { 'allow_cluster_multicast':
    order   => '6',
    content => "-s ${cluster_nets} -m addrtype --src-type MULTICAST -j ACCEPT"
  }
}
