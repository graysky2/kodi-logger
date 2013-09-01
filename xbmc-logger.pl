#!/usr/bin/perl
use warnings;
use strict;
use File::Copy;
use DB_File;

my $w_dir = "$ENV{HOME}/.xbmc/temp";
my $l_dir = "$ENV{HOME}/.xbmc";
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
	if ($line =~ m/^(\S+)\s.*NOTICE: DVDPlayer: Opening: (.*)/) {
		my $ts = $1;
		my $dn = $2;
		if (!$seen{$ts}) {
			print {$ofh} "$now $dn\n";
			$seen{$ts} = 1;
		}
	}
}
