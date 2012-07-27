#!/router/bin/perl
use strict;

print @ARGV;
my $str;
if(@ARGV < 1 ) {
    $str="Mangesh1234567890abcdteufhfj";
} else {
    $str = shift @ARGV;
}

my $i;
my @chars = split(//,$str);

my $len = @chars;

print "len = $len \n";

for($i=0;$i<$len;$i++){
    if(($i)%2 == 0){
        if(( $i)%16 == 0){
            printf("\n %d\t",$i/2);
        } else {
            print " ";
        }
    }
    print  "@chars[$i]";
}

print "\n";
