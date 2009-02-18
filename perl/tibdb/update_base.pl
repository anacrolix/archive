#!/usr/bin/perl -w

use strict;
#use Getopt::Std;

use lib 'private/tibia';
require "tibia.pl";
require "tibdb.pl";

my $world = 'Dolera';
my %update_list;

#add characters given in command line
warn "Adding characters from command line: " . join(', ', @ARGV);
undef $update_list{$_} foreach @ARGV;

#add victims who have no level associated with their death
# $dbh = open_db();
# $sth = query($dbh, 'SELECT distinct chars.name FROM chars, deaths WHERE chars.id=deaths.victim AND deaths.level=0');
# while (my @row = $sth->fetchrow_array()) {
#     last if scalar @update_list >= $update_limit;
#     push @update_list, $row[0];
# }
# $sth->finish;
# close_db($dbh);

#add chars with no residence to update list
# $dbh = open_db();
# $sth = query($dbh, 'SELECT name FROM chars WHERE residence IS NULL');
# while (my @row = $sth->fetchrow_array()) {
#     last if scalar @update_list >= $update_limit;
#     push @update_list, $row[0];
# }
# $sth->finish;
#close_db($dbh);

Tibia::DB::update_chars(sort keys %update_list);
