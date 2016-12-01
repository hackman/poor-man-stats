#!/bin/bash
path=/var/cache/stats

loadavg=''
tcp=''
udp=''
procs=''

function collect_stats {
	loadavg=($(</proc/loadavg))

	# 0  - all connections
	# 1  - incomming
	# 2  - outgoing
	# 3  - http in
	# 4  - http out
	# 5  - https in
	# 6  - https out
	# 7  - varnish
	# 8  - redis
	# 9  - mysql 3306
	# 10 - mysql 3307
	# 11 - opensrs
	# 12 - memcached
	tcp=($(awk -f /root/tcp-analyze.awk /proc/net/tcp))

	# 0 - all connections
	# 1 - DNS queries to us
	# 2 - DNS queries from us
	# 3 - DNS queries to google
	# 4 - other UDP traffic
	udp=($(awk -f /root/udp-analyze.awk /proc/net/udp))

	procs=($(for i in /proc/[0-9]*/cmdline; do echo "$(<$i)"; done 2>/dev/null|awk -f /root/proc-analyze.awk))
}

function save_json {
	s="$(date +%s)000"
	echo "{x:$s,y:${loadavg[0]}}," >> $path/load.js
	echo "{x:$s,y:${procs[0]:-0}}," >> $path/procs.js
	echo "{x:$s,y:${procs[1]:-0}}," >> $path/php.js
	echo "{x:$s,y:${procs[2]:-0}}," >> $path/nginx.js
	echo "{x:$s,y:${procs[3]:-0}}," >> $path/http.js
	echo "{x:$s,y:${procs[4]:-0}}," >> $path/hive.js
	echo "{x:$s,y:${tcp[0]:-0}}," >> $path/tcp.js
	echo "{x:$s,y:${tcp[1]:-0}}," >> $path/in.js
	echo "{x:$s,y:${tcp[2]:-0}}," >> $path/out.js
	echo "{x:$s,y:${tcp[3]:-0}}," >> $path/httpin.js
	echo "{x:$s,y:${tcp[4]:-0}}," >> $path/httpout.js
	echo "{x:$s,y:${tcp[5]:-0}}," >> $path/httpsin.js
	echo "{x:$s,y:${tcp[6]:-0}}," >> $path/httpsout.js
	echo "{x:$s,y:${tcp[7]:-0}}," >> $path/varnish.js
	echo "{x:$s,y:${tcp[8]:-0}}," >> $path/redis.js
	echo "{x:$s,y:${tcp[9]:-0}}," >> $path/mysql3306.js
	echo "{x:$s,y:${tcp[10]:-0}}," >> $path/mysql3307.js
	echo "{x:$s,y:${tcp[11]:-0}}," >> $path/opensrs.js
	echo "{x:$s,y:${tcp[12]:-0}}," >> $path/memcached.js
	echo "{x:$s,y:${udp[0]:-0}}," >> $path/udp.js
	echo "{x:$s,y:${udp[1]:-0}}," >> $path/dnstous.js
	echo "{x:$s,y:${udp[2]:-0}}," >> $path/dnsfromus.js
	echo "{x:$s,y:${udp[3]:-0}}," >> $path/dnstogoogle.js
	echo "{x:$s,y:${udp[4]:-0}}," >> $path/udpother.js
	if [ "${tcp[4]}" -gt 13 ]; then
		netstat -ntp|grep -E ':80\s+[A-Z]' > $path/tcpconns/$s.conns
	fi
}

if [ $# == 1 ]; then
	while true; do
		collect_stats
		save_json	
		sleep 1
	done
else
	collect_stats
	echo "Load: ${loadavg[0]}"
	echo "Procs: ${loadavg[3]/*\/}"
	echo -e "\tPHP: ${procs[0]}\n\tNginx: ${procs[1]}\n\tApache: ${procs[2]}\n\thive-exec: ${procs[3]}"
	echo "TCP conns: ${tcp[0]}"
	echo "TCP services: ${tcp[1]}(incomming) ${tcp[2]}(outgoing)"
	echo "HTTP conns: ${tcp[3]}(incomming) ${tcp[4]}(outgoing)"
	echo "HTTPS conns: ${tcp[5]}(incomming) ${tcp[6]}(outgoing)"
	echo "MySQL 3306 conns: ${tcp[9]}"
	echo "MySQL 3307 conns: ${tcp[10]}"
	echo "Redis conns: ${tcp[8]}"
	echo "Memcached conns: ${tcp[12]}"
	echo "Varnish conns: ${tcp[7]}"
	echo "OpenSRS conns: ${tcp[11]}"
	echo "UDP conns: ${udp[0]}"
	echo -e "DNS queries:\n\tto us: ${udp[1]}\n\tfrom us:${udp[2]}\n\tto google:${udp[3]}\n\tother: ${udp[4]}"
fi
