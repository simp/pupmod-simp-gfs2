# This class starts a luci server on this node.
#
# In order to allow luci, set the trusted_nets variable accordingly.
# The following ports and connection types will be opened up in that case:
#
#  Port Number   Type  Use
#  8084          TCP   luci access
#
# @param trusted_nets
#   For widest subnet accessibility, set this to nets2cidr($trusted_nets)
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class gfs2::server (
  Optional[Simplib::Netlist] $trusted_nets = undef
){

  package { 'luci': ensure => 'latest' }

  service { 'luci':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['luci']
  }

  if $trusted_nets {
    iptables::listen::tcp_stateful { 'allow_luci':
      trusted_nets => $trusted_nets,
      dports       => [ 8084 ],
      require      => Service['luci']
    }
  }
}
