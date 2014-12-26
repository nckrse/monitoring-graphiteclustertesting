#The following is needed if you are not using puppet db
$haproxy_vip='192.168.56.203'
$haproxy1_ip='192.168.56.201'
$haproxy2_ip='192.168.56.202'
$graphite1_ip='192.168.56.201'
$graphite2_ip='192.168.56.202'

$haproxy_master='192.168.56.201'

#The haproxy vip is used for all load balancing
$graphiteweb_vip = $haproxy_vip #accessible by all hosts and user browsers
$graphiteinput_vip = $haproxy_vip #accessible by all hosts
$elasticsearch_vip = $haproxy_vip #accessible by all user browsers
$rabbitmq_vip = $haproxy_vip #accessible by all hosts

import 'nodes/*.pp'
import 'roles/*.pp'
