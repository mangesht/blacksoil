
use strict;

my @a;
my @b;
my $i;
my $a_s = int(rand(100));
my $b_s = int(rand(100));
my $nums = int(rand(10000));
for($i=0;$i<$nums;$i++){

    $a[$i] = int(rand(100)+$a_s);
    $b[$i] = int(rand(100)+$b_s);
}
my @c= sort{$a <=> $b}(@a);
my @d= sort{$a <=> $b}(@b);
#$c[0]=29;
#$c[1]=36;
#$c[2]=49;
#$c[3]=56;
#$c[4]=61;
#$c[5]=63;
#$c[6]=87;
#$c[7]=88;
#$c[8]=113;
#$c[9]=116;
#
#$d[0]=85;
#$d[1]=93;
#$d[2]=94;
#$d[3]=126;
#$d[4]=128;
#$d[5]=143;
#$d[6]=143;
#$d[7]=146;
#$d[8]=153;
#$d[9]=165;

#$c[0]=10;
#$c[1]=13;
#$c[2]=21;
#$c[3]=24;
#$c[4]=25;
#$c[5]=27;
#$c[6]=42;
#$c[7]=49;
#$c[8]=61;
#$c[9]=73;
#
#$d[0]=73;
#$d[1]=106;
#$d[2]=108;
#$d[3]=109;
#$d[4]=118;
#$d[5]=121;
#$d[6]=148;
#$d[7]=149;
#$d[8]=153;
#$d[9]=157;



print "\n";

my $n = @a;
my @s = (@c,@d);
print "\n";
@s = sort{$a <=> $b}(@s);
foreach my $k (@s){
    print " $k ";
}
my $medExp = $s[$n];
print "Median is $s[$n] and $s[11] \n ";
for($i=0;$i<40;$i++){
#	print"\n";
}

my $rt_a = $n-1; 
my $lt_a = 0 ; 
my $e1 = 0 ; 
my $e2 = 0 ; 
my $head_a;
my $head_b;
my $lt_b=0;
my $rt_b=$n-1;
my $b_ind;
my $a_ind;
$head_a = $rt_a;
$head_b = $rt_b;

my $medCalc;
print "n= $n \n";
my $loop_count = 0 ; 
while((($rt_a - $lt_a ) > 1) && ( $rt_b - $lt_b > 1 )) {
    $loop_count++;
    $b_ind = $n-1-$head_a;
    print "While starts \n";
    print "Head_a $head_a lt_a $lt_a rt_a $rt_a b_ind $b_ind \n";
    if($b_ind > 0 ) {
        print "Compaing $c[$head_a] > $d[$b_ind] \n";
        if($c[$head_a] >= $d[$b_ind]){
                print "Compaing $c[$head_a] > $d[$b_ind+1] \n";
                if($c[$head_a] <= $d[$b_ind+1]){
                    #This is match
                    $lt_a = $rt_a; 
                    $medCalc = $c[$head_a]; 
                    print " 1A This is the median $c[$head_a] at Index $head_a \n";
                }else{
                        # head is greater than both , we need to come down 
                        $rt_a = $head_a; 
                        $head_a = int(($rt_a+$lt_a) / 2) ; 
                }
        }else{
                # head is smaller , increase head
                $lt_a = $head_a ; 
                $head_a = int(($rt_a+$lt_a) / 2) ; 
        }
    }else{
        if($c[$head_a] <= $d[$b_ind+1]) {
                $medCalc = $c[$head_a]; 
                print " 2A This is the median $c[$head_a] at Index $head_a \n";
                $lt_a = $rt_a; 
        }else{
        $head_a = int(($rt_a + $lt_a) / 2 );
    }
    }

    # FOR C 
    $a_ind = $n-1-$head_b;
    print "Head_b $head_b lt_b $lt_b rt_b $rt_b a_ind $a_ind \n";
    if($a_ind >= 0 ) { 
        print "Comparing $d[$head_b] > $c[$a_ind] \n";
        if($d[$head_b] >= $c[$a_ind]){
                if($d[$head_b] <= $c[$a_ind+1]){
                    #This is match
                    $lt_b = $rt_b; 
                    $medCalc = $d[$head_b]; 
                    print "1B This is the median $d[$head_b] at Index $head_b \n";
                }else{
                        # head is greater than both , we need to come down 
                        $rt_b = $head_b; 
                        $head_b = int(($rt_b+$lt_b) / 2) ; 
                }
        }else{
                # head is smaller , increase head
                $lt_b = $head_b ; 
                $head_b = int(($rt_b+$lt_b) / 2) ; 
        }
    }else{
        if($d[$head_b] <= $c[$b_ind+1]) {
                $medCalc = $d[$head_b]; 
                print "2B This is the median $d[$head_b] at Index $head_b \n";
        }else{
            $head_b = int(($rt_b + $lt_b) / 2) ;
        }
    }


}


for($i=0;$i<$n;$i++){
	my $j= $i+1;
    print "$i-$c[$i] ";
}
print "\n";
for($i=0;$i<$n;$i++){
	my $j= $i+1;
    print "$i-$d[$i] ";
}

print "\nLoop count = $loop_count \n";
if($medExp == $medCalc) { 
        print "\n MATCH       for $n\n";
}else{
        print "\n ERROR NO   MATCH       \n";
}

