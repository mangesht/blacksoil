#!/usr/bin/perl
use strict;

my $line;

$line = "Rupesh Shweta went to school";
$line =~ /(Mangesh|Shweta)/;

print "Who did go to school ? $&  also $1 \n"; 

# Search for word that has zxw " [abc] means a or b or c 

$line =~ /\w*[zxw]\w*/;

print "The word is $& \n";
