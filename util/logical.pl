#!/usr/bin/perl
use strict;

my $a ; 
my $b ;
my $c ; 

$a = "0000001ffffff0003c880000002003fff";
$b=  "000c00203ec18301e84000040a607c000";
if(@ARGV>1){
        $a = shift @ARGV;
        $b = shift @ARGV;
}
printf("A = %s\n", $a) ;
printf("B = %s\n", $b) ;
my @op1 = split(//,$a);
my @op2 = split(//,$b);
my @op3;
    my $t1 ;
    my $t2 ; 
    my $t4 ="";
for(my $i= 0;$i<=$#op1;$i++){
    $t1 = hex $op1[$i]; 
    $t2 = hex $op2[$i];
    $t1 = $t1 & $t2;
    $op3[$i] =  hex $t1;
    #printf("t1 = %x op1 = %x op2 = %x \t", $t1,hex $op1[$i],hex $op2[$i]);
    $c = join ("",@op3);
    $t4 = sprintf("%s%1x",$t4,$t1);
}
printf("C = %s \n",$t4); 
