#!/usr/bin/perl 
use Modern::Perl;
use FindBin qw/$Bin/;
use lib "$Bin/lib";

use GameSalad::XML::Expand;

# Syncs the game project directory
#  into another directory in the robotswarm
#  git repository.
#  Then expands all the xml in the expanded dir.
#  This way, the valid gamesalad xml AND the expanded,
#  readable xml, are included in the same repo and in 
#  the same commits.

my $base    = "$Bin/../../";
my $in_dir  = "$base/PlatformerExample.gameproj/";
my $out_dir = "$base/expanded/";

die 'in dir cannot be the same as out dir' if $in_dir eq $out_dir;
die "in_dir ($in_dir) must exist" if not -e $in_dir;
die "out_dir ($out_dir) must exist" if not -e $out_dir;

say "Syncing $in_dir to $out_dir";
my $cmd = "rsync -av --delete $in_dir $out_dir";
say `$cmd`;
die "Sync failed ($?): $!" if $?;

my $xml = GameSalad::XML::Expand->new(
	dir => $out_dir,
);

$xml->expandAll();
