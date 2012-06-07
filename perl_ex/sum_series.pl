use strict;

my $n;
my $lin_sum = 0;
my $sqr_sum = 0;
$n=41;

for(my $i=1;$i<=$n;$i++){
	$lin_sum = $lin_sum + $i;
	$sqr_sum = $sqr_sum + $i * $i;
}

print "Sum 1 to $n  = $lin_sum \n" ;
print "Sqr sum 1 to $n  = $sqr_sum \n" ;

my $formula;

$formula = $n*$n*$n / 3 + $n*$n/2 + $n / 6  ; 

print "Value by formula = $formula \n";

