#!/usr/local/bin/perl
use strict;

my $data; 
my $lower_idx; 
my $upper_idx;  
my $diff ;

my $num_val = @ARGV;

if($num_val < 1 ) { 
    print "Enter data to be search for \t" ; 
    $data = <STDIN> ; 
    print "Enter upper index \t";
    $upper_idx = <STDIN>;
    print "Enter lower index \t";
    $lower_idx = <STDIN>;
} elsif ($num_val < 2 ) {
    $data = shift @ARGV ; 
    print "Enter upper index \t";
    $upper_idx = <STDIN>;
    print "Enter lower index \t";
    $lower_idx = <STDIN>;
}elsif($num_val <3) {
    $data = shift @ARGV ; 
    $upper_idx = shift @ARGV;
    print "Enter lower index \t";
    $lower_idx = <STDIN>;
}else {
    $data = shift @ARGV ; 
    $upper_idx = shift @ARGV;
    $lower_idx = shift @ARGV;
}
$data = hex($data);
$data = $data / (2**($lower_idx));
$diff = $upper_idx - $lower_idx + 1 ;
if($diff != 0 ) {
    $data = $data & (2**$diff -1 ) ;
}else {
    print "Diff ne 0 \n"; 
    $data = $data & (2-1 ) ;
}
# $data = shift $data;

printf("Data[%d:%d] = %x \n",$upper_idx,$lower_idx,$data);
