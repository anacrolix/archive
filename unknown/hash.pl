#!/usr/bin/perl -w

$backquote = `md5sum $ARGV[0]`;
$funccall = system("md5sum $ARGV[0]");

print "backquotes gave : $backquote\n";
print "system call gave: $funccall\n";

