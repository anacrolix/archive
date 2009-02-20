#!/usr/bin/perl

print "Content-type: text/html\n\n";

print scalar (getlogin || getpwuid($<) || "Kilroy");