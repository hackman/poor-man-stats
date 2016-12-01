BEGIN {
	all=0
	php=0
	nginx=0
	httpd=0
	hive=0
}
{
	if ($0 ~ /php/) php++;
	if ($0 ~ /nginx/) nginx++;
	if ($0 ~ /httpd/) httpd++;
	if ($0 ~ /hive/) hive++;
	all++;
}
END {
	print all,php,nginx,httpd,hive;
}
