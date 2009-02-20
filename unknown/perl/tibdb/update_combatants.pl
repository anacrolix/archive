#!/usr/bin/perl -w

use strict;
#use Getopt::Std;

use lib 'private/tibia';
require "tibia.pl";
require "tibdb.pl";

my $world = 'Dolera';
my %update_list;
my %online_chars;

#get current online chars
warn "Getting online characters from $world";
%online_chars = Tibia::hash_world_online_list ($world);
print STDERR "Found ", scalar keys %online_chars, " characters online on ", $world, ".\n";

#determine what characters to update
{
    my $dbh = Tibia::DB::open_db();
#add previous online chars
    {
	my $sth = Tibia::DB::query
	    ($dbh, 
	     'SELECT name FROM chars WHERE online=1 AND vocation!=\'N\' AND world=(SELECT id FROM worlds WHERE name=?) ORDER BY name', 
	     $world);
	print STDERR "Database contained ", $sth->rows, " previously online non-rook characters\n";
	while (my @row = $sth->fetchrow_array()) {
	    warn "Adding previously online character: $row[0]";
	    undef $update_list{$row[0]};
	}
	$sth->finish;
    }
#add currently online chars
    foreach (sort keys %online_chars) {
	next if ($online_chars{$_}{vocation} eq 'N');
	warn "Adding online character: \"$_\" $online_chars{$_}{level} $online_chars{$_}{vocation}";
	undef $update_list{$_};
    }
#reset online stati
    warn "UPDATE ONLINE STATI";
    Tibia::DB::query
	($dbh, 
	 'UPDATE chars SET online=0 WHERE world=(SELECT id FROM worlds WHERE name=?)', 
	 $world);
    foreach (keys %online_chars) {
	Tibia::DB::query
	    ($dbh, 
	     'INSERT INTO chars (name, online, world, vocation, level)'.
	     'VALUES (?,?,(SELECT id FROM worlds WHERE name=?),?,?)'.
	     'ON DUPLICATE KEY UPDATE online=VALUES(online), world=VALUES(world), vocation=VALUES(vocation), level=VALUES(level)', 
	     $_, 1, $world, $online_chars{$_}{vocation}, $online_chars{$_}{level});
      }
    warn "Set " . (scalar keys %online_chars) . " characters to online";
    Tibia::DB::close_db($dbh);
}

Tibia::DB::update_chars(sort keys %update_list);
