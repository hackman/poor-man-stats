#!/bin/bash
cwd=$(pwd)
cd /var/cache/stats;
count=0
sep=''
results=''
# Period in seconds
stats_period='7200'
echo 'var points = {' > server-stats.js
for i in *.js; do
	if [ $i == 'server-stats.js' ]; then continue; fi
	e=$(tail -n$stats_period $i|sed '$s/,$//')
	if [ $count -gt 0 ]; then
		sep=','
	else
		count=1
	fi
	echo "${sep}\"${i/.js}\":[$e]" >> server-stats.js
done
echo '}' >> server-stats.js
cd $cwd
