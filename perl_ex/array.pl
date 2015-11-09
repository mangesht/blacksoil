#!/usr/local/bin/perl
use strict;
use List::Util qw(shuffle);

my @data = (20 , 30 , 40 , 50 ,10 );

$data[5] = 25;
print "Using For Loop \n";
for(@data){
    print "Element = $_ \n";
}
my $v;
print "Using for Each After Shuffling  \n";
@data = shuffle @data;

foreach my $k(@data){
        print "Element = $k\n";
}
@data = sort @data;
print "\nAfter Sorting \n";
foreach my $k(@data){
        print "Element = $k \n";
}

print "Top Index of array = $#data \n";
my $num = @data;
printf("Length = %d \n",$num);
for(my $i=0;$i<$num;$i++){
    print "Array [$i] = $data[$i] \n";
}

print "Actual Array @data \n";
print "Trying splice \n";
splice(@data,4,1); # This would remove 4th index element (starting from 0)from array print "Actual Array @data \n";


my @AoA;
my $i;
my $j;
for($i=0;$i<5;$i++){
    for($j=0;$j<5;$j++){
         $AoA[$i][$j][0] = $i * $j;
         print "$AoA[$i][$j][0] ";
    }
    print "\n";
}
