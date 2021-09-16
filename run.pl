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
my $port=7681;
my $externalip="127.0.0.1";	#set to 0.0.0.0 to make the container available from the whole internet

GetOptions(
	"image=s", => \ $image,
	"container=s", => \ $container,
	"tag=s", => \ $tag,
	"hostname=s", => \ $hostname,
	"secps=s", => \ $secondprocess,
	"interactive", => \ $interactive,
	"port", => \ $port,
	"externalip", => \ $externalip,
) or die "Wrong arguments";
my $how="--rm --hostname $hostname --name $container";
if($interactive ne "") {
	$how .= " -it";
} else {
	$how .= " -d";
}
system "docker run $how --hostname $hostname --name $container -p $externalip:$port:7681 $image:$tag $secondprocess";
