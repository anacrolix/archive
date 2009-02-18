#!/usr/bin/perl

use strict;

#$href;
my $href;
#$href->{msg} = 'hi';
$href->{bob} = 'fag';
test(\$href);
print $href->{msg};
print $href->{bob};
sub test {
	my $p = shift;
    undef $$p;
	print "hi from sub\n";
    print "$$p->{msg}\n";
    $$p->{msg} = 'bye';
    print "bye from sub\n";
}