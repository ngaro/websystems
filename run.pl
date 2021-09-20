#!env perl
use v5.24;
use strict;
use warnings;
use Getopt::Long;

my $image="websystem:latest"; my $container="websystem";
my $hostname="websystem";
my $secondprocess="login";	#user can only get root rights when in sudo
#my $secondprocess="/bin/bash";	#user will have root rights
my $extport=7681;
my $extip="127.0.0.1";	#set to 0.0.0.0 to make the container available from the whole internet
my $interactive="";
my $nosysbox="";

GetOptions(
	"image=s", => \ $image,
	"container=s", => \ $container,
	"hostname=s", => \ $hostname,
	"secps=s", => \ $secondprocess,
	"extip=s", => \ $extip,
	"extport=s", => \ $extport,
	"interactive", => \ $interactive,
	"nosysbox", => \ $nosysbox,
) or die "Wrong arguments";
my $how="--rm --hostname $hostname --name $container -p $extip:$extport:7681";
if($interactive ne "") {
	$how .= " -it";
} else {
	$how .= " -d";
}
my $sysbox="";
$sysbox="--runtime=sysbox-runci" if($nosysbox eq "");
system "docker run $sysbox $how $image $secondprocess";
