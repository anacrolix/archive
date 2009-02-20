#!/usr/bin/perl

package Tibia;

use strict;
use LWP::Simple;
use HTML::Entities;
use Date::Parse;
use Net::HTTP::NB;

my $LINK_WORLD_ONLINE_LIST = 'http://www.tibia.com/community/?subtopic=whoisonline&world=';
my $LINK_CHAR_PAGE = 'http://www.tibia.com/community/?subtopic=characters&name=';
my $LINK_GUILD_PAGE = 'http://www.tibia.com/community/?subtopic=guilds&page=view&GuildName=';

my $RE_WORLD_ONLINE_LIST_CHAR = '<TR BGCOLOR=#[0-9A-Za-z]+><TD WIDTH=70%><A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">([^<>]+)</A></TD><TD WIDTH=10%>(\d+)</TD><TD WIDTH=20%>([^<>]+)</TD></TR>';
#<TR BGCOLOR=#D4C0A1><TD WIDTH=70%><A HREF="http://www.tibia.com/community/?subtopic=characters&name=Lowix">Lowix</A></TD><TD WIDTH=10%>165</TD><TD WIDTH=20%>Royal Paladin</TD></TR>

my $RE_CHAR_PAGE_LEVEL = '<TD>Level:</TD><TD>(\d+)</TD>';
#<TD>Level:</TD><TD>16</TD>

my $RE_CHAR_PAGE_VOCATION = '<TD>Profession:</TD><TD>([^<>]+)</TD>';
#<TD>Profession:</TD><TD>Knight</TD>

my $RE_CHAR_PAGE_GUILD = '<TR BGCOLOR=#[0-9A-Za-z]+><TD>Guild&#160;membership:</TD><TD>[^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=guilds&page=view&GuildName=[^\"]+">([^<>]+)</A></TD></TR>';
#<TR BGCOLOR=#F1E0C6><TD>Guild&#160;membership:</TD><TD>Family of the <A HREF="http://www.tibia.com/community/?subtopic=guilds&page=view&GuildName=Ruff+Ryders">Ruff&#160;Ryders</A></TD></TR>

my $RE_CHAR_PAGE_DEATH = '<TR BGCOLOR=#[A-Za-z0-9]+><TD WIDTH=25%>([^<>]+)</TD><TD>(?:Killed|Died)? at Level (\d+) by ([^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">)?([^<>]+)(?:</A>)?</TD></TR>(?:\s+<TR BGCOLOR=#[0-9A-Za-z]+><TD WIDTH=25%></TD><TD>and by ([^<>]*<A HREF="http://www.tibia.com/community/\?subtopic=characters&name=[^\"]+">)?([^<>]+)(?:</A>)?</TD></TR>)?';
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%>Jun&#160;10&#160;2007,&#160;08:48:28&#160;CEST</TD><TD>Killed at Level 51 by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Orelius">Orelius</A></TD></TR>
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%></TD><TD>and by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Maiden+Juliet">Maiden&#160;Juliet</A></TD></TR>
#<TR BGCOLOR=#F1E0C6><TD WIDTH=25%>May&#160;18&#160;2007,&#160;06:20:50&#160;CEST</TD><TD>Killed at Level 44 by <A HREF="http://www.tibia.com/community/?subtopic=characters&name=Bones%27Sage">Bones'Sage</A></TD></TR>
#<TR BGCOLOR=#D4C0A1><TD WIDTH=25%>May&#160;25&#160;2007,&#160;13:01:22&#160;CEST</TD><TD>Died at Level 48 by a necromancer</TD></TR>

my $RE_CHAR_PAGE_WORLD = '<TR BGCOLOR=#[A-Z0-9]{6}><TD>World:</TD><TD>([^<>]+)</TD></TR>';
#<TR BGCOLOR=#F1E0C6><TD>World:</TD><TD>Dolera</TD></TR>

my $RE_CHAR_PAGE_SEX = '<TR BGCOLOR=#[A-Z0-9]{6}><TD>Sex:</TD><TD>([^<>]+)</TD></TR>';
#<TR BGCOLOR=#D4C0A1><TD>Sex:</TD><TD>male</TD></TR>

my $RE_CHAR_PAGE_RESIDENCE = 'TR BGCOLOR=#[A-Z0-9]{6}><TD>Residence:</TD><TD>([^<>]+)</TD></TR>';
#<TR BGCOLOR=#D4C0A1><TD>Residence:</TD><TD>Venore</TD></TR>

my $RE_CHAR_PAGE_ACCOUNT_STATUS = '<TR BGCOLOR=#[A-Z0-9]{6}><TD>Account&#160;Status:</TD><TD>([^<>]+)</TD></TR>';
#<TR BGCOLOR=#D4C0A1><TD>Account&#160;Status:</TD><TD>Premium Account</TD></TR>

my $RE_CHAR_PAGE_BANISHED = '<TD[^<>]*>Banished:</TD><TD[^<>]*>([^<>]*)</TD>';
#<TR BGCOLOR=#D4C0A1><TD WIDTH=20% VALIGN=top CLASS=red>Banished:</TD><TD CLASS=red>until Aug&#160;03&#160;2007,&#160;09:22:35&#160;CEST because of offensive statement</TD></TR>

sub thtml2plain ($) {
    my ($html) = @_;
    decode_entities($html);
    $html =~ tr/\xA0/ /;
    return $html;
}

sub abbr_vocation ($) {
    my ($vocation) = @_;
    $vocation =~ tr/A-Z//cd;
    return $vocation;
}

sub parse_char_page_html ($$) {
    my ($html, $char_name) = @_;
    my %char;
    $html =~ m|$RE_CHAR_PAGE_LEVEL| or warn "Can't match level: $char_name" and return;
    $char{level} = $1;
    $html =~ m|$RE_CHAR_PAGE_VOCATION| or warn "Can't match vocation: $char_name" and return;
    $char{vocation} = abbr_vocation($1);
    if ($html =~ m|$RE_CHAR_PAGE_GUILD|) {
    	$char{guild} = thtml2plain($1);
    }
    if ($html =~ m|$RE_CHAR_PAGE_ACCOUNT_STATUS|) {
	$char{status} = thtml2plain($1);
    }
    if ($html =~ m|$RE_CHAR_PAGE_BANISHED|) {
	$char{banished} = thtml2plain($1);
    }
    $html =~ m|$RE_CHAR_PAGE_SEX| or warn "Can't match sex: $char_name" and return;
    $char{sex} = uc substr $1, 0, 1;
    $html =~ m|$RE_CHAR_PAGE_WORLD| or warn "Can't match world: $char_name" and return;
    $char{world} = $1;
    $html =~ m|$RE_CHAR_PAGE_RESIDENCE| or warn "Can't match residence: $char_name" and return;
    $char{residence} = $1;
    while ($html =~ m|$RE_CHAR_PAGE_DEATH|g) {
	my @death_vars = ($1, $2, $3, $4, $5, $6);
	my %death;
	$death{timestamp} = str2time(thtml2plain($death_vars[0]));
	$death{level} = $death_vars[1];
	if (defined $death_vars[5]) {
	    $death{lasthit}{name} = thtml2plain($death_vars[5]);
	    $death{lasthit}{isplayer} = defined $death_vars[4];
	    $death{mostdamage}{name} = thtml2plain($death_vars[3]);
	    $death{mostdamage}{isplayer} = $death_vars[2] ne '';
	} else {
	    $death{lasthit}{name} = thtml2plain($death_vars[3]);
	    $death{lasthit}{isplayer} = defined $death_vars[2];
	}
	push @{$char{deaths}}, \%death;
    }
    return %char;
}

sub hash_world_online_list ($) {
    my ($world_name) = @_;
    my $world_link = $LINK_WORLD_ONLINE_LIST . $world_name;
    my $world_html = get($world_link) or die "get($world_link): $!";
    my %online_chars;
    while ($world_html =~ m|$RE_WORLD_ONLINE_LIST_CHAR|g) {
    	my $char_name = thtml2plain($1);
        $online_chars{$char_name}{level} = $2;
        $online_chars{$char_name}{vocation} = abbr_vocation($3);
#        $char_info{$char_name} = $online_chars{$char_name} if not defined $char_info{$char_name};
    }
    return %online_chars;
}

sub get_char_page_link ($) {
    my ($char_name) = @_;
    $char_name =~ tr/ /+/;
    return $LINK_CHAR_PAGE . $char_name;
}

sub get_guild_page_link ($) {
    my ($guild_name) = @_;
    $guild_name =~ tr/ /+/;
    return $LINK_GUILD_PAGE . $guild_name;
}

sub nbget_char_init ($) {
    my ($char_name) = @_;
#    warn "Initializing nonblocking get for $char_name";
    my $http_nb_request = Net::HTTP::NB->new(Host => 'www.tibia.com') or die $@;
    $char_name =~ tr/ /+/;
    my $get_request = '/community/?subtopic=characters&name='.$char_name;
    $http_nb_request->write_request(GET => $get_request);
    return $http_nb_request;
}

sub nbget_char_wait ($$) {
    my ($http_nb_request, $char_name) = @_;
    my @response_headers = $http_nb_request->read_response_headers;
    warn "Invalid header response ($response_headers[0]) for $char_name" and return unless $response_headers[0] == 200;
    my ($char_html, $buffer);
    while ($http_nb_request->read_entity_body($buffer, 0x100000)) {
	$char_html .= $buffer;
    }
    my %char = parse_char_page_html($char_html, $char_name);
    return %char;
}
