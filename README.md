HAPROXY Graphite Cluster
========================

2 node cluster, each node consisting of graphite/grafana/haproxy

####clone
```
git clone https://github.com/pythianreese/monitoring-graphiteclustertesting.git
```

####install modules
```
cd monitoring-graphiteclustertesting
r10k puppetfile install -v
```
####run puppet
```
change variables in site.pp to match yours

puppet apply site.pp --modulepath=./modules
```

####dashboards
```
HAPROXY: node 1 => http://haproxy1_ip/haproxy?stats
HAPROXY: node 2 => http://haproxy2_ip/haproxy?stats

Elasticsearch head: node 1 => http://graphite1_ip/_plugin/head/
Elasticsearch head: node 2 => http://graphite2_ip/_plugin/head/

Graphite: => http://graphiteweb_vip/
Grafana: => http://graphiteweb_vip/grafana/
```
