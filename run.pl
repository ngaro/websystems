#!env perl
use strict;
use warnings;
use Getopt::Long;

my $image="websystem"; my $container="websystem";
my $tag="latest";
my $hostname="websystem";
my $secondprocess="login";	#user can only get root rights when in sudo
#my $secondprocess="/bin/bash";	#user will have root rights
my $interactive="";

GetOptions(
	"image=s", => \ $image,
	"container=s", => \ $container,
	"tag=s", => \ $tag,
	"hostname=s", => \ $hostname,
	"secps=s", => \ $secondprocess,
	"interactive", => \ $interactive,
) or die "Wrong arguments";
my $how="--rm --init --hostname $hostname --name $container";
if($interactive ne "") {
	$how .= " -it";
} else {
	$how .= " -d";
}
system "docker run $how --hostname $hostname --name $container $image:$tag init $secondprocess";
my $ip = `docker inspect --format '{{ .NetworkSettings.IPAddress }}' $container`; chomp $ip;
if($interactive eq "") { print "You can access the interface at http://$ip:7681\n"; }
