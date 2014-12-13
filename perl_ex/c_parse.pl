#!/usr/bin/local/perl
use strict;
use Parse;
use Getopt::Long;

# Get the user inputs
my @inpFList;
my @fList;
my $f;
GetOptions('f=s'=> \@inpFList);
printf "\n@ARGV\n";

# Copy all the files in inpFList to fList 
# THen copy everythig else in arglist 
foreach $f(@ARGV){
    $fList[@fList] = $f;
}

printf "ARG List @fList \n";
