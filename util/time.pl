#!/router/bin/perl
use strict;
my $hex_num = 0;
my $sec;
my $min;
my $hour;
my $mday;
my $mon;
my $year;
my $wday;
my $yday;
my $isdst;
#if(@ARGV >0){
#    $hex_num = shift @ARGV;
#}
#printf("Dec = %d \n",hex $hex_num);

my $t = localtime();
print "Time = $t \n";

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time); 

print "Sec = $sec";
