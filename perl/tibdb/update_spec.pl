#!/usr/bin/perl -w

use strict;
#use Getopt::Std;

use lib 'private/tibia';
require "tibia.pl";
require "tibdb.pl";

my $world = 'Dolera';
my %update_list;
my $update_file = shift @ARGV;
my $max_chars = shift @ARGV;

warn "Update file: $update_file";
warn "File is not plain" unless -f $update_file;
warn "File is not writable" unless -w $update_file;
warn "File is not readable" unless -r $update_file;

open(UPDFH, '<', $update_file) or die "Can't read file: $!";
my @update_chars = <UPDFH>;
close UPDFH;

chomp @update_chars;
@update_chars = sort @update_chars;
undef $update_list{shift @update_chars}
  while (scalar keys %update_list < $max_chars and @update_chars);

open(UPDFH, '>', $update_file) or die "Can't write file: $!";
print UPDFH join($/, @update_chars);
close UPDFH;

#query for additional required updates
# {
#     my $dbh = open_db();
#     my $sth = query($dbh, 'SELECT distinct chars.name FROM chars, deaths WHERE chars.id=deaths.victim AND deaths.level=0');
#     while (my @row = $sth->fetchrow_array()) {
# 	last if scalar @update_list >= $update_limit;
# 	push @update_list, $row[0];
#     }
#     $sth->finish;
#     close_db($dbh);

# #add chars with no residence to update list
#     $dbh = open_db();
#     $sth = query($dbh, 'SELECT name FROM chars WHERE residence IS NULL');
#     while (my @row = $sth->fetchrow_array()) {
# 	last if scalar @update_list >= $update_limit;
# 	push @update_list, $row[0];
#     }
#     $sth->finish;
# #close_db($dbh);
#}
Tibia::DB::update_chars(sort keys %update_list);

