#!/bin/env perl

use strict;
use warnings;

use Term::ProgressBar;
use Getopt::Std;

my ($path, $collapse, $delete);
&check_params;
print "Path     : $path\n";
print "Collapse : ", $collapse ? 'On' : 'Off', "\n";
print "Rm Dupes : ", $delete ? 'Yes' : 'No', "\n";
my @files = &get_file_listing($path);
my %hashes = &generate_hashes(@files);
&show_duplicates(%hashes);
&delete_dupes(%hashes) if $delete;
&flat_collapse(%hashes) if $collapse;

sub delete_dupes (%) {
    my %hashes = @_;
    foreach my $hash (keys %hashes) {
	my $duplicates = scalar @{$hashes{$hash}};
	next unless $duplicates > 1;
	printf "Found %d files with hash %s\n", $duplicates, $hash;
	print "Preserving ", $hashes{$hash}->[0],"\n";
	foreach my $i (1 .. $duplicates - 1) {
	    my $file = quotemeta $hashes{$hash}->[$i];
	    system('rm -i '.$file);	    
	}
    }
    
}

sub flat_collapse (%) {
    if (not -e $collapse) {
	system('mkdir -pv '.$collapse) and die;
    }
    foreach my $hash (keys %hashes) {
	system ('cp -v '.(quotemeta $hashes{$hash}->[0])." $collapse/$hash") and die;
    }
}

sub check_params () {
    my %opts;
    getopts('p:c:d', \%opts);
    $path = $opts{p};
    &usage if not $path;
    die "Invalid path: $path" if not -d $path;
    $collapse = $opts{c};
    $delete = $opts{d};
}

sub get_file_listing ($) {
    my ($path) = @_;
    print 'Reading directory ';
    my @files = `find '$path' -type f`;
    die "No files found or find failed: $path" if not @files;
    print '.';
    chomp @files;
    print '.';
    my @dirs = `find '$path' -type d`;
    die "Directory count failed: $path" if not @dirs;
    # first directory is path, remove it
    shift @dirs;
    print ".\n";
    # present results
    printf "Found %u files in %u subfolders\n", scalar @files, scalar @dirs;
    return @files;
}  

sub generate_hashes (@) {
    my @files = @_;
    my $progress = Term::ProgressBar->new
	({count => scalar @files,
	  name => 'Generate hashes',
	  ETA => 'linear',
	 });
    my %hashes;
    foreach (@files) {
	my $file = quotemeta;
	my $hash = `md5sum $file`;
	die "Hashing call failed: $file" if not $hash;
	die "Unable to read hash results: $hash" if not $hash =~ /([0-9a-f]{32})  (.+)/;
	if ($hashes{$1}) {
	    push @{$hashes{$1}}, $2;
	} else {
	    $hashes{$1} = [$2];
	}
	$progress->update;
    }
    print "\n";
    return %hashes;
}


sub usage {
    print "Usage: perl $0 [path]\n";
    print "Locate duplicate files using MD5 checksums.\n";
    print "\n", 'Report bugs to <stupidape@hotmail.com>', "\n";
    exit;
}

sub show_duplicates (%) {
    my %hashes = @_;
    my $dupes_exist;
    print "Listing duplicates ...";
    print "None\n" and return if (not %hashes);
    foreach my $hash (keys %hashes) {
	next unless scalar @{$hashes{$hash}} > 1; 
	if (not $dupes_exist) {
	    print "\n";
	    $dupes_exist = 1;
	}
	print "$hash:\n", join("\n", @{$hashes{$hash}}, '');
    }
    print " None!\n" if not $dupes_exist;
}
