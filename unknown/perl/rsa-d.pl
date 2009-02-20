#!/usr/bin/perl

$totient = 160;
$e = 3;

$k = 0;
while ((1 + $k * $totient) % $e != 0) {$k++;}
print "private exponent := ", ((1 + $k * $totient) / $e), "\n";
