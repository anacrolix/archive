#!/usr/bin/perl -w

use strict;

my $BASE64_DIGITS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
my ($input, $totalBytes, $bytesRead);
$totalBytes = 0;
for (;;) {
    $bytesRead = read STDIN, $input, 3;
    last unless ($bytesRead > 0);
    $input = unpack("N",pack("xC3",unpack("C3",$input)));
    my $output = '';
    for (my $i=3;$i>=0;$i--) {
	my $digit = (($input >> ($i*6)) & 0b111111);
	$output .= substr $BASE64_DIGITS, $digit, 1;
	#print $digit, ' ';
    }
    $output = substr($output, 0, $bytesRead+1) . '='x(3-$bytesRead) if ($bytesRead < 3);
    print $output;
}
