# == Class gfs2::server
#
# This class starts a luci server on this node.
#
# In order to allow luci, set the cluster_nets variable accordingly.
# The following ports and connection types will be opened up in that case:
#
#  Port Number   Type  Use
#  8084          TCP   luci access
#
# == Parameters
#
# [*cluster_nets*]
#   For widest subnet accessibility, set this to nets2cidr($client_nets)
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class gfs2::server (
  $cluster_nets = []
){

  package { 'luci': ensure => 'latest' }

  service { 'luci':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['luci']
  }

  if ! empty($cluster_nets) {
    iptables::add_tcp_stateful_listen { 'allow_luci':
      client_nets => $cluster_nets,
      dports      => '8084',
      require     => Service['luci']
    }
  }
}
