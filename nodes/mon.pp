node /^mon/ {

include monit

class {'graphitecluster::elasticsearch::base': }->
class {'graphitecluster::elasticsearch::config': }->
class {'graphitecluster::elasticsearch::monit': }->

class {'graphitecluster::apache::base': }->
class {'graphitecluster::apache::config': }->
class {'graphitecluster::graphite::user': }->
class {'graphitecluster::graphite::base': }->
class {'graphitecluster::graphite::postconfig': }->
class {'graphitecluster::grafana::base': }->
class {'graphitecluster::apache::monit': }->
class {'graphitecluster::graphite::monit': }

class {'haproxycluster::keepalive::base': }->
class {'haproxycluster::keepalive::config': }->

class {'haproxycluster::haproxy::base': }->
class {'haproxycluster::haproxy::admin': }->

class {'haproxycluster::haproxy::graphiteweb': }->
class {'haproxycluster::haproxy::graphiteinput': }->
class {'haproxycluster::haproxy::elasticsearch': }->

class {'haproxycluster::haproxy::members': }

}
