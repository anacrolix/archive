#!/usr/bin/perl -w

$usage = 
    "\nUsage: perl $0 NUM_BYTES [OUTPUT_FILE]\n" .
    "Creates a binary file of NUM_BYTES random bytes in OUTPUT_FILE\n\n"; 

my $bytes_remaining = shift @ARGV or print $usage and exit;
my $output_file = shift @ARGV;

if ($output_file) {
    open (FILE, '>', $output_file) or die "Couldn't open file for output: $!\n";
    binmode(FILE);
} else {
    *FILE = \*STDOUT;
}

my ($long_max, $char_max) = (2**32, 2**8);
while ($bytes_remaining >= 4) {
    print FILE pack("L", int(rand($long_max)));
    $bytes_remaining -= 4;
}
while ($bytes_remaining > 0) {
    print FILE pack("C", int(rand($char_max)));
    $bytes_remaining -= 1;
}
close FILE;
