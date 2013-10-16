#!/usr/bin/perl
use strict;

my $line;

$line = "ClassClass 2 20 students";
$line =~ /(Class){2}/;

print "Class $1 The match is $& \n";

$line = "ClassClassClassClass noClassClassClass";
$line =~ /(Class){3,5}/;
print "Range match is $& \n";
$& =~/Class/i;
$line = "ClassClass 2 20 students";
$line =~ /(Class){2}/;
print "noLower bound Range match is $& \n";

