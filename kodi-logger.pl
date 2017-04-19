#!/usr/bin/perl

# kodi-logger version 1.4
#
# CHANGELOG
# v1.0  Initial release
# V1.1  Now works with Kodi on x86 or ARM
# v1.2	Works with Gotham+
# v1.3	Renamed for Kodi rename and tested on up to Krypton
# v1.4	More generic processing

use warnings;
use strict;
use File::Copy;
use DB_File;

# this is the directory where kodi.log is expected
#my $w_dir = "$ENV{HOME}/.kodi/temp";
my $w_dir = '/var/lib/kodi/.kodi/temp';

# this is the dir where you wish to write out the kodi-watched.log
# if you want it to be something outside of your user's home dir like
# /var/log for example, that location must have an empty kodi-watched.log
# present and owned by the user:group you wish to run the script as 
# or else this script will fail to write to the log
my $l_dir = '/var/log';
my $t_dir = '/tmp';
my $now = localtime();

my $state_fn = "$t_dir/state_db";
my $db_obj = tie my %seen, 'DB_File', $state_fn
	or die "Unable to tie to state file $state_fn\n";
my $fn = "$w_dir/kodi.log";
my $ofn = "$l_dir/kodi-watched.log";

open my $ofh, '>>', $ofn
	or die "Unable to open file $ofn for writing ($!). Stopped";
open my $fh, '<', $fn
	or die "Unable to open file $fn for reading ($!). Stopped";

while (my $line = <$fh>) {
	chomp $line;
	if ($line =~ m/^(\S+)\s.*Player: Opening: (.*)/) {
		my $ts = $1;
		my $dn = $2;
		if (!$seen{$ts}) {
			print {$ofh} "$now $dn\n";
			$seen{$ts} = 1;
		}
	}
}
