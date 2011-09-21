#!/usr/bin/perl

################################################################################
# cacheCommand.pl
################################################################################
# This program caches the output of a cli program.  If the error regex is
# matched, the cached output is displayed insteadof the actual program output.
# This is especially useful when a command requires a network connection to
# function, but you can't be bothered to stop your program from running.
#
# v.01 First (and probably last version)
################################################################################

use warnings;
use strict;

use Config::General;
use File::HomeDir;
use Data::Dumper 'Dumper';

my $CONFIG_FILE = sprintf "%s/.cacheCommandrc", File::HomeDir->my_home;
my $conf = new Config::General($CONFIG_FILE);
my %config = $conf->getall;

mkdir($config{"CACHE_DIR"}) or die("Eror creating directory $config{'CACHE_DIR'}")
	if not(-d $config{"CACHE_DIR"});

my $filename = sprintf("%s/.%s", $config{"CACHE_DIR"}, join("_", @ARGV));
my @output = `@ARGV`;

if($output[0] =~ /$config{"Error_Regex"}{join("_", @ARGV)}/) {
	undef(@output);
	open(my $file, "<", $filename) or die($!);
	while(<$file>) {
		print $_;
	}
	close($file);
} else {
	open(my $file, ">", $filename) or die($!);
	print $file @output;
	close($file);
	print @output;
}

