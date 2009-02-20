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
	#last;
}
#while (read STDIN, $input, 3) {
#	my @bytes, $padding;
#	@bytes = unpack("CCC", $input);
#	for (3..0) {
#		print((($bytes >> ($_ * 6)) & 0b111111), ' ');
#	}
#	print "\n";
	#my @bytes = unpack("CCC", $input);
	#my $padding = '';
	#for (0..2) {
	#	unless (defined $bytes[$_]) {
	#		$bytes[$_] = 0;
	#		$padding .= '=';
	#	}
	#}
	#if (undef $bytes[$_]) {$bytes[$_] = 0; $padding .= '=';} for (1..3);
	#print "Was: ", join(' ', @bytes), ' ';
	#my @base64;
	#push @base64, $bytes[0] >> 2;
	#push @base64, ((($bytes[0] & 0b11) << 4) | (($bytes[1] >> 4) & 0b1111));
	#push @base64, ((($bytes[1] & 0b1111) << 2) | (($bytes[2] >> 6) & 0b11));
	#push @base64, $bytes[2] & 0b111111;
	#foreach (@base64) {
#		$_ = substr $BASE64_DIGITS, $_, 1;
#	}
#	print @base64, "\n";
#	undef @base64;
	#for $digit (0..3) {
	
	#print "Not 3 bytes: " if @bytes < 3;
	#foreach (@bytes) {
	#	print $_, " ";
	#	$num_bytes++ if ($_ or $_ == 0);
	#}
#}
