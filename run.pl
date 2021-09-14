#!env perl
use strict;
use warnings;
use Getopt::Long;

my $image="websystem"; my $container="websystem";
my $tag="latest";
my $hostname="websystem";
my $firstpid="login";	#user can only get root rights when in sudo
#my $firstpid="/bin/bash";	#user will have root rights
my $interactive="";

GetOptions(
	"image=s", => \ $image,
	"container=s", => \ $container,
	"tag=s", => \ $tag,
	"hostname=s", => \ $hostname,
	"firstpid=s", => \ $firstpid,
	"interactive", => \ $interactive,
) or die "Wrong arguments";
my $how="--rm --hostname $hostname --name $container";
if($interactive ne "") {
	$how .= " -it";
} else {
	$how .= " -d";
}
system "docker run $how --hostname $hostname --name $container $image:$tag ttyd $firstpid";
