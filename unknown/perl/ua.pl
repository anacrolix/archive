#!/usr/bin/perl

use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;

my $ua = LWP::UserAgent->new;

my $response = $ua->get($request);

if ($response->is_success) {
	print $response->content;
} else {
	die $response->status_line;
}