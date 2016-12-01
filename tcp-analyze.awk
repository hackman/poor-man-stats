BEGIN {
	all=0
	incomming=0
	outgoing=0
	http_in=0
	http_out=0
	https_in=0
	https_out=0
	varnish=0
	redis=0
	mysql3306=0
	mysql3307=0
	opensrs=0
	memcashed=0
}
{
	all++;
	# port 80    in hex is 0050		HTTP
	# port 83	 in hex is 0053		Varnishd
	# port 443   in hex is 01BB		HTTPS
	# port 6379  in hex is 18EB		Redis
	# port 3306  in hex is 0CEA		MySQL on 3306
	# port 3307  in hex is 0CEB		MySQL on 3307
	# port 24007 in hex is 5DC7		GlusterFS
	# port 11211 in hex is 2BCB		Memcached
	# port 55000 in hex is D6D8		OpenSRS API
	if ( $2 ~ /:0050$/ ) { http_in++; incomming++; }
	if ( $3 ~ /:0050$/ ) { http_out++; outgoing++; }
	if ( $2 ~ /:01BB$/ ) { https_in++; incomming++; }
	if ( $3 ~ /:01BB$/ ) { https_out++; outgoing++; }
	if ( $3 ~ /:0053$/ ) varnish++;
	if ( $3 ~ /:2BCB$/ ) memcached++;
	if ( $3 ~ /:D6D8$/ ) { opensrs++; outgoing++; }
	if ( $3 ~ /:18EB$/ ) { redis++; outgoing++; }
	if ( $3 ~ /:0CEA/ ) { mysql3306++; outgoing++; }
	if ( $3 ~ /:0CEB/ ) { mysql3307++; outgoing++; }
	
}
END {
	print all,incomming,outgoing,http_in,http_out,https_in,https_out,varnish,redis,mysql3306,mysql3307,opensrs,memcached
#	print http_in+http_out+https_in+https_out+redis+mysql3306+mysql3307+opensrs+memcached+varnish
}
