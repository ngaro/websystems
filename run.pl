#!env perl
use strict;
use warnings;
use Getopt::Long;

my $image="websystem"; my $container="websystem";
my $tag="latest";
my $hostname="websystem";
my $firstpid="login";	#user can only get root rights when in sudo
#my $firstpid="/bin/bash";	#user will have root rights

GetOptions(
	"image=s", => \ $image,
	"container=s", => \ $container,
	"tag=s", => \ $tag,
	"hostname=s", => \ $hostname,
	"firstpid=s", => \ $firstpid,
) or die "Wrong arguments";
system "docker run -it --rm --hostname $hostname --name $container $image:$tag ttyd $firstpid";
