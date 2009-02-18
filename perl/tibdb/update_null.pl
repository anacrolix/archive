#!/usr/bin/perl -w

use strict;
#use Getopt::Std;

use lib 'private/tibia';
require "tibia.pl";
require "tibdb.pl";

my $world = 'Dolera';
my %update_list;

my $dbh = Tibia::DB::open_db();
my $sth = Tibia::DB::query($dbh, 'SELECT name FROM chars WHERE level=0 or level IS NULL or residence is null or status is null');
print STDERR "Found ", $sth->rows, " non-conforming rows\n";
while (my @row = $sth->fetchrow_array()) {
    undef $update_list{$row[0]};
}
$sth->finish;
Tibia::DB::close_db($dbh);

Tibia::DB::update_chars(sort keys %update_list);

