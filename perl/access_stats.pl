#!/usr/bin/perl

# hash count a bunch of stuff from standard access_log files
# Matt Joiner <stupidape@hotmail.com> 2007
# usage: perl access_stats.pl path/access_log

$results_file = $ARGV[0];

print "Results file: \t$results_file\n";

for $i (1 .. $#ARGV) {
	$log_file = $ARGV[$i];
	print "\($i/$#ARGV\) Processing:\t$log_file\n";
	&process_logs($log_file);
}

sub process_logs {
	my ($log_file) = @_;
	open (LOGFILE, "$log_file") or print "Can't open log file \"$log_file\": $!\n" and return;
	my ($url, $line);
	for $line (<LOGFILE>) {
		#print "Retrieved line:\t$line";
		#if ($line =~ m/(^(?:\d{1,3}\.){3}\d{1,3})/) {
		#	$ip_requests{$1}++;
		#	#print "Found IP:\t$1\n";
		#}
		if ($line =~ m/(^(?:\d{1,3}\.){3}\d{1,3}).*\[.*?:(\d*):.*\] \"(?:POST|GET) (\S*).*\" (\d*).*\"(\S*)\"/) {
			#print "Line extracted\n";
			$request_ips{$1}++;
			$request_hour{$2}++;
			$url = $3;			
			$request_status{$4}++;
			$request_referrer{$5}++;
			if ($url =~ /([^\?=&]*)/) {$request_url{$1}++;}
			if ($url =~ /[^\?]*\.([a-z0-9]+)/) {$request_filetype{$1}++;}
		} else {
			print "$line";
		}
	}
	close LOGFILE;
}

open (RESULTSFILE, ">$results_file") or die "Can't open results file: $!";

&report_request("URL requests", %request_url);
&report_request("Status code results", %request_status);
&report_request("Requested file types", %request_filetype);
&report_request("Hour of requests", %request_hour);
&report_request("Request referrers", %request_referrer);
&report_request("Requester address", %request_ips);

close RESULTSFILE;

sub report_request {
	my ($header, %type) = @_;
	print RESULTSFILE "\n$header:\n";
	for $type (sort {$type{$b} <=> $type{$a}} keys %type) {
		print RESULTSFILE "$type{$type}\t$type\n";
	}
}

