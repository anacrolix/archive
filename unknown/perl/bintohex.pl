#!/usr/bin/perl

open(FILE, "<" . shift @ARGV) or die "Can't open input file: $!\n";
binmode(FILE);
print unpack("H*", join '', <FILE>);
close FILE;
