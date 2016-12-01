BEGIN {
	all=0
	google=0
	tous=0
	dnsq=0
	other=0
}
{
	all++;
	# port 53    in hex is 0035		DNS
	if ( $2 ~ /:0035$/ ) tous++;
	if ( $3 ~ /:0035$/ ) {
		dnsq++;
		if ( $3 ~ /^08080808/ || $3 ~ /^04040808/ ) google++;
	}
	if ( $2 !~ /:0035$/ && $3 !~ /:0035$/ ) other++;
	
}
END {
	print all,tous,dnsq,google,other
}
