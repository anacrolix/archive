#!/usr/bin/perl -w

use strict;
use English;
use Net::Ping;
use Time::Format;
use Time::HiRes;
use Mail::Sendmail;
use File::stat;
use Getopt::Std;
#use IO::Handle;

#set globals and default options
my %alert_mail = (
		  Smtp => 'localhost',
		  From => 'ServaMon <servamon@eruanno.com>',
#		  Bcc => 'EruServaMon Debug <servamon@eruanno.com>',
		  );
my @portless_protocols = qw(icmp);
my $ping_period = 60; #seconds between ping cycles
my $offline_repeat = 15; #minutes to repeat offline
my $timeout = 1; #ping timeout delay
my $time_format = 'hh:mm Day dd Mon yyyy'; #unix time format
my $hosts_conf = 'pinghosts.conf';
my $ping_retries = 8;
my $log_file = 'STDOUT';

#get options 
#s=smtp server; f=config file
my %opts;
getopts('s:f:l:', \%opts);
$alert_mail{Smtp} = $opts{s} if defined $opts{s};
$hosts_conf = $opts{f} if defined $opts{f};
$log_file = $opts{l} if defined $opts{l};
die "$hosts_conf does not exist!\n$!" if !-e $hosts_conf;
$alert_mail{To} = shift or print "You must specify alert recipients" and exit;

if (defined $opts{l}) {
    open(LOG, '>>', $log_file) or die "open logfile ($log_file): $!";
    select(LOG);
    $|=1;
}

#display options
print join "\n",
    "SMTP Server: $alert_mail{Smtp}",
    "Alert recipients: $alert_mail{To}",
    "Conf file: $hosts_conf",
    "Log file: $log_file",
    ''
    ;

my $href_pinghosts; #hash reference
my $next_ping = time;
my $hosts_conf_mtime = 0;
my $pinger;
my $alert_count = 0;

#load_pinghosts_conf($hosts_conf, \$href_pinghosts);

#my $io = new IO::Handle;
#$io->fdopen(fileno(STDOUT),"w") or die "io fdopen: $!";
#$io->autoflush(1);
#undef $io;

#$|=1;

while (1) {
    #wait until next ping period
    sleep(1) while time < $next_ping;
    $next_ping += $ping_period;
    #if conf file has changed, reload it
    if (stat($hosts_conf)->mtime > $hosts_conf_mtime) {
    	$hosts_conf_mtime = stat($hosts_conf)->mtime;
        load_pinghosts_conf($hosts_conf, \$href_pinghosts);
    }
    #print "loaded file\n";
    #test all services
    print "Testing all services: ", time_format($time_format), "\n" or die "print: $!";
    my $time_testall = time;
    foreach my $host (sort keys %$href_pinghosts) {
    	foreach my $protocol (sort keys %{$href_pinghosts->{$host}}) {
	    if (grep /$protocol/i, @portless_protocols) {
            	ping_service($host, $protocol);
            } else {
		foreach my $port (sort keys %{$href_pinghosts->{$host}->{$protocol}}) {
		    ping_service($host, $protocol, $port);
                }
            }
        }
    }
    print "All services tested: ", time_format($time_format), " (took ", time - $time_testall, " seconds).\n";
}

sub load_pinghosts_conf {
    my ($file, $href) = @_;

#    undef $$href;
    open FILE, '<:crlf', $file or die "Hosts config file: $!";
    while (<FILE>) {
    	chomp;
        my ($host) = (m/^\s*([A-Za-z0-9\.\-]+)/);
        next if (!defined $host);
        my $rem = $POSTMATCH; #was $'
        my $protocol;
        while ($rem =~ m/([A-Za-z]+)\s*(?:\((.*?)\))?/g) {
	    my $protocol = $1;
#            warn 'Error in hosts conf file' and last if (!defined $2 and grep /$protocol/i, $portless_protocols);
	    my @services;
            if (grep /$protocol/i, @portless_protocols) {
            	push @services, \$$href->{$host}->{$protocol};
            } elsif (not defined $2) {
            	warn "Services for $host ".uc($protocol)." must be specified" and last;
            } else {
            	foreach (split /[\s,:]+/, $2) {
		    push @services, \$$href->{$host}->{$protocol}->{$_};
                }
            }
            foreach (@services) {
            	$$_->{down} = 0 if not defined $$_->{down};
                $$_->{fresh} = 1;
            }
        }
    }
    close FILE;
    #remove old entries
    foreach my $host (keys %{$$href}) {
        foreach my $protocol (keys %{$$href->{$host}}) {
            if (grep /$protocol/i, @portless_protocols) {
            	if ($$href->{$host}->{$protocol}->{fresh}) {
		    delete $$href->{$host}->{$protocol}->{fresh};
                } else {
		    delete $$href->{$host}->{$protocol};
                }
	    } else {
                foreach my $service (keys %{$$href->{$host}->{$protocol}}) {
                    if ($$href->{$host}->{$protocol}->{$service}->{fresh}) {
                        delete $$href->{$host}->{$protocol}->{$service}->{fresh};
                    } else {
                        delete $$href->{$host}->{$protocol}->{$service};
                    }
                }
            }
        }
    }
    print "Loaded hosts configuration file: $file\n";
    return;
}

sub str_duration {
    my $time = shift @_;
    my @unit = qw(s m hr d);
    my @max = (60, 60, 24);
    my (@duration, $i);
    for ($i=0;$i<@max;$i++) {
    	unshift @duration, int($time%$max[$i]).$unit[$i];
        $time = int($time/$max[$i]);
        last if not $time;
    }
    unshift @duration, $time.$unit[$i] if not $time;
    return join ' ', @duration;
}

sub ping_service {
    my ($host, $protocol, $port) = @_;
    #print "entered ping_service()\n";
    #ping
    $pinger = Net::Ping->new($protocol, $timeout);
    $pinger->hires(1);
    $pinger->service_check(1);
    $pinger->{port_num} = ($port !~ /^\d+$/ ? getservbyname($port, $protocol) : $port) if defined $port;
#    print "$port=", scalar ($port !~ /^\d+$/ ? getservbyname($port, $protocol) : $port), "\n" if defined $port;
    my ($replied, $duration, $ip) = $pinger->ping($host) or warn "pinger failed: $!";    
    print "Pinging: $host\t", defined $port ? "$port/" : '', "$protocol\t";
    if (not defined $ip) {
	print uc "unresolved\n";
    } else {
	print uc "$ip\t";
    }
    #$|=1; 
    if (!$replied) {
	for (my $retries = 0; $retries < $ping_retries; $retries++) {
	    print '.';
	    ($replied, $duration, $ip) = $pinger->ping($host) or warn "pinger failed: $!";
	    print "\t" and last if $replied;
	    #$|=1;
	}	    
    }
    if ($replied) {
	print 'OK', sprintf('%4.0fms',1000*$duration);
    } else {
	print 'FAILED';
    }
    print "\n";
    #email
    my $service;
    if (defined $port) {
	$service = \$href_pinghosts->{$host}->{$protocol}->{$port};
    } else {
	$service = \$href_pinghosts->{$host}->{$protocol};
    }
    #send email
    my $do_email = 1;
    my ($subject, @message);
    my $full_service = $host.' '.(defined $port ? "$port/" : '').$protocol;
    if ($replied and $$service->{down}) { #came back up
	print "$full_service has recovered.\n";
	$subject = 'Recovered';
	push @message, "Status: Recovered";
	push @message, "Went down: ".$time{$time_format, $$service->{down}};
	push @message, "Downtime: ".str_duration(time-$$service->{down});
	$$service->{down} = 0;
    } elsif (!$replied and !$$service->{down}) { #just went down
	print "$full_service just failed.\n";
	$subject = 'Failure';
	push @message, "Status: Failure";
	$$service->{down} = time;
	$$service->{repeat} = time + $offline_repeat * 60;
    } elsif (!$replied and $$service->{down} and $offline_repeat and time > $$service->{repeat}) {
	print "$full_service has been down for ", int((time-$$service->{down})/60), " minutes.\n";
	$subject = 'Offline';
	push @message, "Status: Offline";
	push @message, "Went down: ".$time{$time_format, $$service->{down}};
	push @message, "Downtime: ".str_duration(time-$$service->{down});
	$$service->{repeat} += $offline_repeat * 60;
    } else {
	$do_email = 0;
    }
    if ($do_email) {
	$alert_mail{Date} = Mail::Sendmail::time_to_date(time);
	$alert_mail{Subject} =
#	    'Alert #'.++$alert_count.' '
	    "$host (".uc($protocol)
	    .(defined $port ? ":$port" : '').') '
	    .$subject;
	$alert_mail{Message} = join "\n",
	"Server: $host (".(defined $ip ? $ip : uc 'Unresolved').')',
	"Service: ".(defined $port ? "$port/" : '').$protocol,
#	"Protocol: ".uc($protocol),
#	"Port: ".(defined $port ? "$port" : 'N/A'),
	"Time: ".$time{$time_format},
	@message, '';
	sendmail(%alert_mail) or die $Mail::Sendmail::error;
    }
}
