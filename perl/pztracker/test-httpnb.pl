#!/usr/bin/perl -w

use strict;
use Net::HTTP::NB;
use LWP::Simple;

sub nb_get_request_init ($$) {
    my ($request_host, $get_request) = @_;
    my $http_nb_request = Net::HTTP->new(Host => $request_host) || die $@;
    $http_nb_request->write_request(GET => $get_request);
    return $http_nb_request;
}

sub nb_get_request_wait ($) {
    my ($http_nb_request) = @_;
    my @response_headers = $http_nb_request->read_response_headers;
    return if not defined $response_headers[0];
    my $entity_body;
    my $buffer;    
    while (my $num_bytes = $http_nb_request->read_entity_body($buffer, 0x1000) > 0) {
	$entity_body .= $buffer;
    }
    return $entity_body;
}

#my @test_chars = qw(BigTwat Lowix Eruanno Snarkz Nyalith Garithanix Edkeys Athraz Kaisier Eruanno Eruanno Yalie);
my @char_html;
my $start_time = time;
foreach my $char_name ('Eruanno') {
    my $req_obj = nb_get_request_init ('www.tibia.com', '/community/?subtopic=characters&name='.$char_name);
    push @char_html, $req_obj;
}
foreach (@char_html) {
    print nb_get_request_wait($_), "\n";
}
print "Non-blocking took ", time-$start_time, " seconds\n";


