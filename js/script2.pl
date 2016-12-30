#!/usr/bin/env perl
#===============================================================================
#
#         FILE: download_02.pl
#
#        USAGE: ./download_02.pl URL SavePath
#
#  DESCRIPTION: Download und so!
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: LWP installation: perl -MCPAN -e'install "LWP::Simple"'
#       AUTHOR: Fabian Schäfer
# ORGANIZATION: FH Südwestfalen, Iserlohn
#      VERSION: 0.02
#      CREATED: 17.04.2016 15:07:30
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use LWP::Simple;
use LWP::UserAgent;

my $url;
my $savepath;

if(scalar(@ARGV) == 2)
{
	$url = "$ARGV[0]";
	$savepath = "$ARGV[1]";
}
else
{
	exit 666;
}

if ($url !~ m/(?i)\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))/)
{
	die "Bitte eine korrekte URL angeben!";
}

my (my $type, my $size) = head($url) or die "Fehler size usw... blabla";

print "\n".$size."\n";

my $ua = LWP::UserAgent->new();

my $fileName = $url;

my @fields = split /\//, $fileName;

$fileName = $fields[$#fields];

my $completePath = "$savepath/$fileName";

my	$datafile_file_name = $completePath;		# input file name

open  my $datafile, '>', $datafile_file_name
	or die  "$0 : failed to open output file '$datafile_file_name' : $!\n";

my $r = $ua->get("$url", ':content_cb' => \&callback);

close  $datafile
	or warn "$0 : failed to close output file '$datafile_file_name' : $!\n";

my $filesize = -s $completePath;

my	$downloadHistory_file_name = 'History.txt';		# output file name

open  my $downloadHistory, '>>', $downloadHistory_file_name
	or die  "$0 : failed to open  output file '$downloadHistory_file_name' : $!\n";

print $downloadHistory $fileName."\t".$url."\t".localtime()."\n";

close  $downloadHistory
	or warn "$0 : failed to close output file '$downloadHistory_file_name' : $!\n";

if ($filesize == $size)
{
print "\nDownload of ".$fileName." completed.\n";
}
else
{
	die "Filesize does not match! Error!";
}



sub callback {
	my ($data, $response, $protocol) = @_;
	print $datafile $data;
	print progress_percent(-s $datafile, $size);
}

sub progress_percent {
	my ( $got, $total ) = @_;
	sprintf "%.2f%%\r", 100*$got/$total;
}

