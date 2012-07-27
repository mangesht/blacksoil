#!/usr/bin/perl
use strict;

my $a= 254;
my $b = 255;
my $e = 1 ; 
my $c;
my $d= 0;
my $q= 0;

my $shift =8  ;

$a = shift @ARGV;
$b = shift @ARGV;

for($shift = 31 ; $shift >=0 ; $shift--){
        $c = $b << $shift;
        $d = $a - $c ; 
           $q = $q << 1 ;
        if($d<0){
        }else{
           ##$q = $q << 1 ; 
           $q = $q +  $e ;
           $a = $d;
        }
        print "Shift = $shift A = $a B = $b  C = $c D = $d \n";
}
 print "Quotient = $q Remainder =  $a \n";
