#!/usr/bin/perl -w

binmode(STDIN);
$_ = join '', <STDIN>;
#print "Received:", $_;
#chomp $_;
$_ =~ tr/0-9A-Fa-f//cd;
#print "Squashed:", $_, "\n";
binmode(STDOUT);
print STDOUT pack("H*", $_);
close STDOUT;
close STDIN;
