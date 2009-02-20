require "tibia.pl";

package Tibia::DB;

use DBI;

my $db_host = 'localhost';
my $db_port = 3306;
my $db_name = 'eruc_tibia_chars';
my $db_user = 'eruc';
my $db_password = 'nooblix';
my $db_engine = 'mysql';

sub query ($$@) {
    my ($dbh, $query, @vars) = @_;
    my $sth;
    eval {
	$sth = $dbh->prepare($query, {RaiseError=>1})
	    or die "Couldn't prepare statement: " . DBI->errstr;
    };
    die $@ if $@;
    eval {
	$sth->execute(@vars)
	    or die "Couldn't execute statement: " . DBI->errstr;
    };
    die $@ if $@;
    return $sth;
}

sub open_db () {
    my $dbh = DBI->connect("DBI:$db_engine:$db_name:$db_host:$db_port", $db_user, $db_password, {PrintError=>1,RaiseError=>1})
	or die "Couldn't connect to database: " . DBI->errstr;
    return $dbh;
}

sub close_db ($) {
    my ($dbh) = @_;
    $dbh->disconnect
	or die "Couldn't disconnect from database: " . DBI->errstr;
}

# sub add_chars (@) {
#     my (@add_list) = @_;
# #tell us how many characters are being added
#     warn "Adding " . scalar @add_list . " characters.";
    
# }

sub update_chars (@) {
    my (@update_list) = @_;

#inform us how many chars will be processed
    warn "Updating " . scalar @update_list . " characters.";

#init all requests
    my @nb_requests;
    {
	my $done = 0;
	foreach (@update_list) {
	    push @nb_requests, Tibia::nbget_char_init($_);
	    $done++;
	    warn '('.$done.'/'.scalar @update_list.')'. ': Initialized non-blocking get on character page for "'.$_.'"';
	} 
    }
#open db and begin inserting new data
    $dbh = open_db();
    foreach my $name (@update_list) {
	my %char = Tibia::nbget_char_wait(shift @nb_requests, $name);
	warn "Failed to retrieve $name" and next if not %char;
	my $sth;
	warn "Non-blocking get on character page for \"$name\" returned";
	die "No world provided for $name" if not defined $char{world};
	for (;;) {
	    $sth = query($dbh, 'SELECT id FROM worlds WHERE name=?', $char{world});
	    die "Duplicate worlds exist" if $sth->rows > 1;
	    last if $sth->rows == 1;
	    query($dbh, 'INSERT INTO worlds (name) VALUES (?)', $char{world});
	}
	my $world_id = ($sth->fetchrow_array())[0];
	$sth->finish;
	my $guild_id;
	if (defined $char{guild}) {
	    $sth = query($dbh, 'SELECT id FROM guilds WHERE name=? AND world=?', $char{guild}, $world_id);
	    die "Duplicate guilds detected" if $sth->rows > 1;
	    if ($sth->rows < 1) {
		query($dbh, 'INSERT INTO guilds (name, world) VALUES (?,?)', $char{guild}, $world_id);
	    }
	    $guild_id = ($sth->fetchrow_array())[0];
	    $sth->finish;
	}
	query($dbh, 'INSERT INTO chars (name, level, vocation, sex, guild, world, residence, status) VALUES (?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE level=values(level), vocation=values(vocation), sex=values(sex), guild=values(guild), world=values(world), residence=values(residence), status=values(status)', $name, $char{level}, $char{vocation}, $char{sex}, $guild_id, $world_id, $char{residence}, $char{status});
	foreach my $death (@{$char{deaths}}) {
	    foreach my $kill ($$death{lasthit}, $$death{mostdamage}) {
		next if not $$kill{isplayer};
		if (query($dbh, 'SELECT * FROM chars WHERE name=?', $$kill{name})->rows != 1) {
		    query($dbh, 'INSERT INTO chars (name) VALUES (?)', $$kill{name});
		}
		query($dbh, 'INSERT INTO deaths (victim, killer, time, level, lasthit) VALUES ((select id from chars where name=?),(select id from chars where name=?),from_unixtime(?), ?, ?)', $name, $$kill{name}, $$death{timestamp}, $$death{level}, ($kill == $$death{lasthit}) ? 1 : 0) if query($dbh, 'SELECT * FROM deaths where victim=(select id from chars where name=?) and killer=(select id from chars where name=?) and time=from_unixtime(?) and level=?', $name, $$kill{name}, $$death{timestamp}, $$death{level})->rows != 1;
	    }
	}
    }
    close_db($dbh);
}
