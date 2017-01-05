# This function opens the following ports and connection types for the provided
# $trusted_nets.
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
# @param trusted_nets
#   For the widest subnet accessibility, set $trusted_nets to
#   nets2cidr(hiera('trusted_nets')).
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class gfs2::cluster_allow (
  Simplib::Netlist $trusted_nets = simplib::lookup('simp_options::trusted_nets', { 'default_value' => ['127.0.0.1'] }),
) {

  iptables::listen::udp { 'allow_cman':
    trusted_nets => $trusted_nets,
    dports       => [ 5404,5405,6809 ]
  }

  # Conga
  iptables::listen::tcp_stateful { 'allow_ricci':
    trusted_nets => $trusted_nets,
    dports       => [ 11111 ]
  }

  iptables::listen::udp { 'allow_ricci':
    trusted_nets => $trusted_nets,
    dports       => [ 11111 ],
    require      => Service['ricci']
  }

  iptables::listen::tcp_stateful { 'allow_gnbd':
    trusted_nets => $trusted_nets,
    dports       => [ 14567 ]
  }

  iptables::listen::tcp_stateful { 'allow_modclusterd':
    trusted_nets => $trusted_nets,
    dports       => [ 16851 ]
  }

  iptables::listen::tcp_stateful { 'allow_dlm':
    trusted_nets => $trusted_nets,
    dports       => [ 21064 ]
  }

  iptables::listen::tcp_stateful { 'allow_ccsd':
    trusted_nets => $trusted_nets,
    dports       => [ 50006,50008,50009 ]
  }

  iptables::listen::udp { 'allow_ccsd':
    trusted_nets => $trusted_nets,
    dports       => [ 50007 ]
  }

  iptables::listen::udp { 'allow_fencing':
    trusted_nets => $trusted_nets,
    dports       => [ 1229 ]
  }

  iptables_rule { 'allow_cluster_multicast':
    order   => 6,
    content => "-s ${trusted_nets} -m addrtype --src-type MULTICAST -j ACCEPT"
  }
}
