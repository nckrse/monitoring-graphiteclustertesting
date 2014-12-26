node /^mon/ {

# GRAPHITE

include monit

class {'graphitecluster::elasticsearch::base': }->
class {'graphitecluster::elasticsearch::config': }->
class {'graphitecluster::elasticsearch::monit': }->

class {'graphitecluster::apache::base': }->
class {'graphitecluster::apache::config': }->
class {'graphitecluster::graphite::base': }->
class {'graphitecluster::grafana::base': }->
class {'graphitecluster::apache::monit': }->
class {'graphitecluster::graphite::monit': }->

# HAPROXY

class {'haproxycluster::keepalive::base': }->
class {'haproxycluster::keepalive::config': }->

class {'haproxycluster::haproxy::base': }->
class {'haproxycluster::haproxy::admin': }->

class {'haproxycluster::redishappy::config': } ->

class {'haproxycluster::haproxy::graphiteweb': }->
class {'haproxycluster::haproxy::graphiteinput': }->
class {'haproxycluster::haproxy::elasticsearch': }->

class {'haproxycluster::haproxy::members': }->

# MONITORING

class {'monitoring::graphite::client': }->
class {'monitoring::graphite::client::monit': }

}
