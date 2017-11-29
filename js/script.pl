#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: download_02.pl
#
#        USAGE: ./download_02.pl URL SavePath
#
#  DESCRIPTION: Perl-Script für den Download von
#  				Dateien in verschiedenen Formaten.
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Fabian Schäfer
# ORGANIZATION: FH Südwestfalen, Iserlohn
#      VERSION: 0.8
#      CREATED: 17.07.2017 15:07:30
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use LWP::Simple;
use LWP::UserAgent;
use FindBin;
use lib $FindBin::Bin;
use URL::RegexMatching qw(url_match_regex http_url_match_regex);

select(STDOUT); $| =1;

my $url; 														# Variable der Downloadadresse.
my $savepath; 													# Variable für den Speicherpfad.
my $url_regex = url_match_regex;								# Variable für die Erkennung einer Adresse.

#-------------------------------------------------------------------------------
# Parameterübernahme.
#-------------------------------------------------------------------------------

if(scalar(@ARGV) == 2)  										# Prüfung ob zwei Parameter übergeben wurden.
{
	$url = "$ARGV[0]";											# Speichern des ersten Parameters als Downloadadresse.
	$savepath = "$ARGV[1]"; 									# Speichern des zweiten Parametes als Speicherpfad.
}
else															# Fehlercode 1 falls weniger oder mehr als zwei Parameter übergeben wurden.
{
	die 1;														# Bitte eine URL und einen Speicherort angeben!
}

if ($url !~ m{$url_regex})  									# Fehlermeldung wenn URL nicht dem Adressmuster entspricht.
{
	die 2; 														# Bitte eine korrekte URL angeben!
}

#-------------------------------------------------------------------------------
# Einrichtung des LWP-Moduls für den Dateidownload.
#-------------------------------------------------------------------------------

my $ua = LWP::UserAgent->new();  								# Anlage eines LWP UserAgenten.
my $result = $ua->head($url); 									# Prüfung ob die Adresse erreichbar ist.
my $remote_headers = $result->headers;							# Auslesen des Headers der Webadresse.
my $size = $remote_headers->content_length or die 3; 			# Größe der Downloaddatei ermitteln. Bei Fehler -> Abbruch des Skripts.

#-------------------------------------------------------------------------------
# Erstellung des Download-Pfades.
#-------------------------------------------------------------------------------

my $fileName = $url;											# Übernahme der URL als Dateiname.

my @fields = split /\//, $fileName; 							# Aufsplitten des Dateinamen.

$fileName = $fields[$#fields];									# Aktualisierung des Dateinamen ( letzer Part der URL ).

my $completePath = "$savepath/$fileName";						# Zusammensetzten des kompletten Speicherpfads

my	$datafile_file_name = $completePath;						# input file name

#-------------------------------------------------------------------------------
# Abspeichern der Datei.
#-------------------------------------------------------------------------------

open  my $datafile, '>', $datafile_file_name
	or die 4;													# "$0 : failed to open output file '$datafile_file_name' : $!\n";

my $r = $ua->get("$url", ':content_cb' => \&callback); 			# Abspeichern der Datei im an das Skript übergebenen Pfad.

close  $datafile
	or warn 5; 													# "$0 : failed to close output file '$datafile_file_name' : $!\n";

my $filesize = -s $completePath; 								# Ermittelung der Dateigröße nach dem Speichern.

#-------------------------------------------------------------------------------
# Erstellung / Aktualisierung einer Download-Historie
#-------------------------------------------------------------------------------

my	$downloadHistory_file_name = 'History.txt';					# History-Datei

open  my $downloadHistory, '>>', $downloadHistory_file_name
	or die 6;  													# "$0 : failed to open  output file '$downloadHistory_file_name' : $!\n";

print $downloadHistory $fileName."\t".$url."\t".localtime()."\n"; # Heruntergeladenen Dateinamen / Adresse / Uhrzeit zur History hinzufügen.

close  $downloadHistory
	or warn 7;  												# "$0 : failed to close output file '$downloadHistory_file_name' : $!\n";

if ($filesize == $size)		# Prüfung ob die Dateigröße auf der Webseite mit der Dateigröße der heruntergeladenen Datei übereinstimmt ( Download erfolgreich? ).
{
print "\nDownload of ".$fileName." completed.\n";				# Erfolgsmeldung bei Übereinstimmung.
}
else															# Fehlermeldung falls nicht.
{
	die 8; 														# Filesize does not match! Error!;
}

#-----------------------------------------------------------------------------------------
# Sub-Callback-Methode für das Speichern der Datei und Anzeigen einer Fortschrittsleiste.
#-----------------------------------------------------------------------------------------

sub callback {
	my ($data, $response, $protocol) = @_;
	print $datafile $data;
	print progress_percent(-s $datafile, $size);
}

#-------------------------------------------------------------------------------
# Sub-Methode für die Prozentuale Anzeige des Download-Fortschritts.
#-------------------------------------------------------------------------------

sub progress_percent {
	my ( $got, $total ) = @_;
	sprintf "%.2f%%\r", 100*$got/+$total;
}

