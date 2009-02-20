#!/usr/bin/perl -w

use File::Copy;

our $filename = 'httpdocs/muck/test.html';
open FILE, '>', $filename.'.'.$$ or die $!;
print FILE 'This page was updated at ', scalar localtime;
close FILE;
move("$filename.$$", $filename) or die $!;