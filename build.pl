#!env perl
use strict;
use warnings;
use File::Temp qw/tempfile/;
use Getopt::Long;

my $image="websystem";
my $user="user";
my $tag="latest";
my $distro="ubuntu"; my $distroversion="20.04";
my $timezone="Europe/Brussels";
my $repo="tsl0922/ttyd"; my $branch="main";
my $minimize='';
my $sudo='';
my $dockerfileonly='';
my $pass="pass";

GetOptions(
	"image=s", => \ $image,
	"tag=s", => \ $tag,
	"distro=s", => \ $distro,
	"distroversion=s", => \ $distroversion,
	"timezone=s", => \ $timezone,
	"repo=s", => \ $repo,
	"branch=s", => \ $branch,
	"user=s", => \ $user,
	"pass=s", => \ $pass,
	"minimize", => \ $minimize,
	"sudo", => \ $sudo,
	"dockerfile-only", => \ $dockerfileonly,
) or die "Wrong arguments";

system("gcc myInit.c -Wall -Wextra -pedantic -o myInit");
my $dockerfile =  << "END";
FROM $distro:$distroversion
RUN ln -s /usr/share/zoneinfo/$timezone /etc/localtime && echo $timezone > /etc/timezone
RUN set -xe && apt-get update && apt-get -y full-upgrade && apt-get -y install --no-install-recommends unzip wget ca-certificates \\
build-essential cmake git libjson-c-dev libwebsockets-dev && \\
cd /root && wget https://github.com/$repo/archive/refs/heads/$branch.zip && unzip $branch.zip && rm $branch.zip && \\
cd /root/ttyd-$branch && mkdir build && cd build && cmake .. && make && make install && cd && rm -rf /root/ttyd-$branch
END
if($minimize ne "") {
	chomp $dockerfile;
	$dockerfile.= << "END"
 && apt-get -y purge wget unzip ca-certificates build-essential cmake git && \\
apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && apt-get update
END
} else {
	$dockerfile .=  "RUN apt-get -y upgrade && apt-get -y install man-db && echo y | unminimize\n";
}
if($sudo ne "") {
	$dockerfile .= "RUN apt-get -y install sudo\n";
}
$dockerfile .=  "RUN rm -f /etc/update-motd.d/60-unminimize /usr/local/sbin/unminimize\n";
if($user ne "") {
	$dockerfile .= "RUN useradd -m -s /bin/bash $user && echo '$user:$pass' | chpasswd\n";
	if($sudo ne "") {
		$dockerfile .= "RUN sudo usermod -a -G sudo $user\n";
	}
}
$dockerfile .=  << "END";
COPY myInit /sbin/init
ENTRYPOINT ["/sbin/init"]
CMD ["/bin/login"]
END
my ($fh, $filename) = tempfile;
print $fh $dockerfile;
close($filename);
if($dockerfileonly eq '') {
	system "docker build -t $image:$tag --file=$filename .";
	unlink $filename;
} else {
	say "The Dockerfile is available in `$filename`";
}
