#!/router/bin/perl
#use strict;
my $hex_num;
print @ARGV;
if(@ARGV >0){
    $hex_num = shift @ARGV;
}
printf("Dec = %d \n",hex $hex_num);
