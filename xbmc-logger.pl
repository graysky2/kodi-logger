#!/usr/bin/perl

# xbmc-logger version 1.1
#
# CHANGELOG
# v1.0  Initial release
# V1.1  Now works with xbmc on x86 or ARM

use warnings;
use strict;
use File::Copy;
use DB_File;

# this is the directory where xbmc.log is expected
my $w_dir = "$ENV{HOME}/.xbmc/temp";

# this is the dir where you wish to write out the xmbc-watched.log
# if you want it to be something outside of the xbmc users home dir like
# /var/log for example, that location must have an empty xbmc-watched.log
# present and owned by the xbmc user:group or else this script will fail
# to write to the log
my $l_dir = "$ENV{HOME}/.xbmc";

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
	if ($line =~ m/^(\S+)\s.*Player: Opening: (.*)/) {
		my $ts = $1;
		my $dn = $2;
		if (!$seen{$ts}) {
			print {$ofh} "$now $dn\n";
			$seen{$ts} = 1;
		}
	}
}
