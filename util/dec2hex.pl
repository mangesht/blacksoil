#!/router/bin/perl
use strict;
my $dec_num = 0;
if(@ARGV >0){
    $dec_num = shift @ARGV;
}
printf("Hex = %x \n",$dec_num);
