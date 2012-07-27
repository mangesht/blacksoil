#!/router/bin/perl
use strict;
my $dec_num = 0;
my $addr=1;
if(@ARGV >0){
    $dec_num = shift @ARGV;
}
printf("Hex = %x \n",$dec_num);
my $mult=1;
do{
        $mult *= 2 ; 
        print ("$mult ");
}while($mult < $dec_num);
printf("valid address are ");
my $init=0;
do{
        $init += 64;
        printf(" $addr ");
        $addr++;

}
while($init < $dec_num);

printf("\n");
while($init < $mult) {
        printf("Invalid Addrees = $addr\n");
        $addr++;
        $init += 64;
}
printf("\n");

