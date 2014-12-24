#!/usr/bin/perl

# xbmc-logger version 1.3
#
# CHANGELOG
# v1.0  Initial release
# V1.1  Now works with xbmc on x86 or ARM
# v1.2	Works with gotham
# v1.3	Minor typos corrected

use warnings;
use strict;
use File::Copy;
use DB_File;

# this is the directory where xbmc.log is expected
#my $w_dir = "$ENV{HOME}/.xbmc/temp";
my $w_dir = '/var/lib/xbmc/.xbmc/temp';

# this is the dir where you wish to write out the xmbc-watched.log
# if you want it to be something outside of your user's home dir like
# /var/log for example, that location must have an empty xbmc-watched.log
# present and owned by the user:group you wish to run the script as 
# or else this script will fail to write to the log
my $l_dir = '/var/log';
#my $l_dir = "$ENV{HOME}/.xbmc";

# this is the dir where a temp db is kept
my $t_dir = '/tmp';
my $now = localtime();

my $state_fn = "$t_dir/state_db";
my $db_obj = tie my %seen, 'DB_File', $state_fn
	or die "Unable to tie to state file $state_fn\n";
my $fn = "$w_dir/xbmc.log";
my $ofn = "$l_dir/xbmc-watched.log";

open my $ofh, '>>', $ofn
	or die "Unable to open file $ofn for writing ($!). Stopped";
open my $fh, '<', $fn
	or die "Unable to open file $fn for reading ($!). Stopped";

while (my $line = <$fh>) {
	chomp $line;
#if ($line =~ m/^(\S+)\s.*Player: Opening: (.*)/) {
	if ($line =~ m/^(\S+)\s.*DVDPlayer: Opening: (.*)/) {
		my $ts = $1;
		my $dn = $2;
		if (!$seen{$ts}) {
			print {$ofh} "$now $dn\n";
			$seen{$ts} = 1;
		}
	}
}
