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
foreach $f(@inpFList){
    my $fname;
    printf "FileList to process $f \n";
    #$fList[@fList] = $f;
    my $parser = new Parse($f);
    $fname = $parser->get_line();
    while(($fname cmp "__EOFPARSE")!=0){
        $fList[@fList] = $fname;
        $fname = $parser->get_line();
    }
}
print "Convering filelists to file entries done \n";
foreach $f(@ARGV){
    $fList[@fList] = $f;
}
printf "ARG List @fList \n";
print "Updating file entries with arugment list is done";

# Start parsing the individual files
# Global data structures 
my %DTC;
my %DT;
# 

my $pstate;

$pstate = "START";
my $token;
my @field_type;
foreach $f(@fList){
    my $parser = new Parse($f);
    while(1){
        if(($pstate cmp "START") == 0){
            # Initialize 
            @field_type = "";            
            
            $token = $parser->get_token();
            if(defined $DTC{$token}){
                $field_type[@field_type] = $token;
                $pstate = "T0";
            }elsif(defined $DT{$token}){
                $field_type[@field_type] = $token;
                $pstate = "T1";
            }
        }
    }
    
}
