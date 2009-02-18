#!/usr/bin/perl -w
use strict;
use Net::FTP;

my ($host, $clhost, $user, $pass, $basedir, $output) =
  ('localhost',
   'localhost',
   'ben',
   'nooblix',
   '/matt\'s music',
   'erupsy.m3u');

sub find_mp3s {
  my ($ftp, $path) = @_;
  my @dir = $ftp->dir($path) or return;
  foreach (@dir) {
    my ($perm, $size, $name) =
      (m/^(\S{10}) \d+ \S+ \S+\s+(\d+) \S+ \S+\s+\S+ (.*)$/);
    my ($type) = ($perm =~ /^(.)/);
    if ($type eq 'd') {
      find_mp3s($ftp, $path.'/'.$name);
    } elsif ($type eq '-' and $name =~ /\.mp3$/i) {
      print
	"ftp://$user:$pass\@$clhost",
	  $path, '/', $name. "\n";
    }
  }
  return;
}

open(PLAYLIST, '>', $output) or die $!;
select PLAYLIST;
print '#EXTM3U', "\n";
my $ftp = Net::FTP->new($host, Debug => 0) or die $@;
$ftp->login($user, $pass) or die $ftp->message;
find_mp3s($ftp, $basedir);
close PLAYLIST;
