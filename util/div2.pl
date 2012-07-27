#!/usr/bin/perl
use strict;

my $a= 60;
my $b = 12;
my $e = 1 ; 
my $c;
my $d= 0;
my $q= 0;
my $mask = 0x0000_001f;

my $shift =8  ;

$a = shift @ARGV;
$b = shift @ARGV;

for($shift = 4 ; $shift >=0 ; $shift--){
        $mask = $mask >> 1 ;
        $c = $a >> $shift;
        $d = $c - $b ; 
        $q = $q << 1 ;
        if($d<0){
        }else{
           ##$q = $q << 1 ; 
           $q = $q +  $e ;
           $a = $a & $mask;
           $d = $d << $shift;
           $a = $a  + $d ;
        }
        print "Shift = $shift A = $a B = $b  C = $c D = $d \n";
}
 print "Quotient = $q Remainder =  $a \n";
