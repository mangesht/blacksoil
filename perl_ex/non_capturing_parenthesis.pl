#!/usr/bin/perl
use strict;

my $line;

$line = "Class 2 20 students";
$line =~ /(Class)? (\d+) (\d+)/i;

print "Class $2 has $3 students \n";

