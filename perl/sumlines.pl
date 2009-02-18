#!/usr/bin/perl

while (<STDIN>) {
	$sum = 0.0;
    $count = 0;
	while (/([\d\.]+)/g) {
    	$sum += $1;
        $count++;
    }
    print $sum/$count, "\n";
}