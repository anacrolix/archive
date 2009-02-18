#!/usr/bin/perl -w

use Digest::MD5 qw(md5_hex);

$usage = 
    "\nUsage: perl $0 digest_file\n\n";
print $usage and exit if (!@ARGV);

$file = shift;
print "file does not exist: $file\n" and exit if !-e $file;

$starttime = time;
open FILE, '<', $file;
$ctx = Digest::MD5->new;
$ctx->add(-s $file);
$ctx->addfile(FILE);
$digest = $ctx->hexdigest;
print "OO style md5_hex digest: $digest (", time-$starttime, " secs)\n";
close FILE;

$starttime = time;
open FILE, '<', $file;
undef $/;
$data = (-s $file) . <FILE>;
$digest = md5_hex($data);
print "Functional style md5_hex digest: $digest (", time-$starttime, " secs)\n";
close FILE;

