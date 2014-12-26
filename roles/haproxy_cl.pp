class haproxycluster::keepalive::base {
include keepalived
sysctl { 'net.ipv4.ip_nonlocal_bind': value => '1' }
keepalived::vrrp::script { 'check_haproxy':
script => '/usr/bin/killall -0 haproxy',
}
}
class haproxycluster::keepalive::config {
if $::ipaddress == $::haproxy_master {
keepalived::vrrp::instance { 'VI_50':
interface => eth0,
state => MASTER,
virtual_router_id => 50,
priority => 101,
auth_type => PASS,
auth_pass => 'secret',
virtual_ipaddress => [ $haproxy_vip ],
track_interface => [ eth0 ], # optional, monitor these interfaces.
track_script => 'check_haproxy',
}
} else {
keepalived::vrrp::instance { 'VI_50':
interface => eth0,
state => 'BACKUP',
virtual_router_id => '50',
priority => '100',
auth_type => 'PASS',
auth_pass => 'secret',
virtual_ipaddress => [ $haproxy_vip ],
track_interface => [ eth0 ], # optional, monitor these interfaces.
track_script => 'check_haproxy',
}
}
}
class haproxycluster::haproxy::base {
#Haproxy Configuration
case $::osfamily {
'redhat': {
yumrepo { "haproxy" :
descr => "Haproxy, The software loadbalancer",
baseurl => "http://download.linuxdataflow.org:81/rpm-repos/haproxy/el${operatingsystemmajrelease}/",
enabled => 1,
gpgcheck => 0,
gpgkey => absent,
exclude => absent,
metadata_expire => absent,
}
}
'debian': {
apt::ppa {'ppa:vbernat/haproxy-1.5': }
}
}->
class { 'haproxy':
global_options => {
'log' => "${ipaddress} local0",
'chroot' => '/var/lib/haproxy',
'pidfile' => '/var/run/haproxy.pid',
'maxconn' => '4000',
'user' => 'haproxy',
'group' => 'haproxy',
'daemon' => '',
'stats' => 'socket /var/lib/haproxy/stats',
},
defaults_options => {
'log' => 'global',
'option' => 'redispatch',
'retries' => '3',
'timeout' => [
'http-request 10s',
'queue 1m',
'connect 10s',
'check 10s',
'client 1m',
'server 1m',
],
'maxconn' => '8000',
},
}
}
class haproxycluster::haproxy::admin {
haproxy::listen { 'admin':
collect_exported => true,
ipaddress => $ipaddress,
mode => 'http',
ports => '8080',
options => {
'stats' => [ 'enable' ],
}
}
}
class haproxycluster::redishappy::config {
class {'redishappy':
haproxy => true,
haproxy_binary => '/usr/sbin/haproxy',
haproxy_pidfile => '/var/run/haproxy_redis.pid',
template_path => '/etc/redishappy-haproxy/haproxy_template.cfg',
output_path => '/etc/haproxy/haproxy_redis.cfg',
clusters => {
},
},
sentinels => {
'haproxy1' => {
'Host' => $::haproxy1_ip,
'Port' => '26379',
},
'haproxy2' => {
'Host' => $::haproxy2_ip,
'Port' => '26379',
},
},
}
}
class haproxycluster::haproxy::graphiteweb {
haproxy::frontend { 'graphite_web':
ipaddress => $haproxy_vip,
mode => 'http',
ports => '80',
options => {
'default_backend' => ['graphite_web_backend'],
'option' => [ 'tcplog' ],
'mode' => 'http',
}
}
haproxy::backend { 'graphite_web_backend':
options => {
'mode' => [ 'http' ],
'balance' => 'roundrobin',
}
}
}
class haproxycluster::haproxy::graphiteinput {
haproxy::frontend { 'graphite_2003':
ipaddress => $haproxy_vip,
ports => '2003',
options => {
'default_backend' => ['graphite_2213_backend'],
'option' => [ 'tcplog' ],
}
}
haproxy::backend { 'graphite_2213_backend':
options => {
'balance' => 'roundrobin',
}
}
}
class haproxycluster::haproxy::elasticsearch {
haproxy::frontend { 'graphite_elasticsearch':
ipaddress => $haproxy_vip,
mode => 'http',
ports => '9200',
options => {
'default_backend' => ['graphite_elasticsearch_backend'],
'option' => [ 'tcplog' ],
'mode' => 'http',
}
}
}
haproxy::backend { 'graphite_elasticsearch_backend':
options => {
'mode' => [ 'http' ],
'balance' => 'roundrobin',
}
}
}
}

class haproxycluster::haproxy::members {

haproxy::balancermember { 'graphite1_web':
listening_service => 'graphite_web_backend',
server_names => "graphite1.$::domain",
ipaddresses => "$graphite1_ip",
ports => '80',
options => 'check',
}
haproxy::balancermember { 'graphite2_web':
listening_service => 'graphite_web_backend',
server_names => "graphite2.$::domain",
ipaddresses => "$graphite2_ip",
ports => '80',
options => 'check',
}
haproxy::balancermember { 'graphite1_2213':
listening_service => 'graphite_2213_backend',
server_names => "graphite1.$::domain",
ipaddresses => "$graphite1_ip",
ports => '2213',
options => 'check',
}
haproxy::balancermember { 'graphite2_2213':
listening_service => 'graphite_2213_backend',
server_names => "graphite2.$::domain",
ipaddresses => "$graphite2_ip",
ports => '2213',
options => 'check',
}
haproxy::balancermember { 'graphite1_elasticsearch':
listening_service => 'graphite_elasticsearch_backend',
server_names => "graphite1.$::domain",
ipaddresses => "$graphite1_ip",
ports => '9200',
options => 'check',
}
haproxy::balancermember { 'graphite2_elasticsearch':
listening_service => 'graphite_elasticsearch_backend',
server_names => "graphite2.$::domain",
ipaddresses => "$graphite2_ip",
ports => '9200',
options => 'check',
}
}
