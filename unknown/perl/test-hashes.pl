#!/usr/bin/perl

#$array[10] = 4;
#push @array, $_ foreach (1..3);
#print @array, "\n";
#delete $_ if $_ == 2 foreach (@array);
#print @array, "\n";
undef $hash{$_} foreach (1..3);
print keys %hash,"\n";
delete $hash{2};
print keys %hash,"\n";
