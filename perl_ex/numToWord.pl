use POSIX;
use strict;
my $data;
my %tens;
my %units;
my %place;
my $itNum;

$tens{0} = "";
$tens{1} = "";
$tens{2} = "Twenty";
$tens{3} = "Thirty";
$tens{4} = "Forty";
$tens{5} = "Fifty";
$tens{6} = "Sixty";
$tens{7} = "Seventy";
$tens{8} = "Eighty";
$tens{9} = "ninty";

$units{0} = "Zero";
$units{1} = "One";
$units{2} = "Two";
$units{3} = "Three";
$units{4} = "Four";
$units{5} = "Five";
$units{6} = "Six";
$units{7} = "Seven";
$units{8} = "Eight";
$units{9} = "Nine";
$units{10} = "Ten";
$units{11} = "Eleven";
$units{12} = "Twelve";
$units{13} = "Thirteen";
$units{14} = "Fourteen";
$units{15} = "Fifteen";
$units{16} = "Sixteen";
$units{17} = "Seventeen";
$units{18} = "Eighteen";
$units{19} = "Ninteeen";
$place{0} = "units";
$place{1} = "Tens";
$place{2} = "Hundred";
$place{3} = "Thousand";
$place{4} = "Lac";
my $num = @ARGV;
$data = shift @ARGV ;
$data = 3668;
print "Input number = $data num = $num \n";
$itNum = 0 ; 
my $rem;
my @final_word;
my $idx=0;
while($data > 0 ){
        if($itNum == 0){
                if($data%100 < 20){
                       $rem = $data % 100 ; 
                       print "UNIT $units{$rem} \n";
                       $final_word[$idx++] = "$units{$rem} " ;
                       $data = floor($data / 100) ;
                       $itNum++;
                }else{
                       $rem = $data % 10 ; 
                       $data = floor($data / 10) ;
                       print "UNIT $units{$rem} \n";
                       $final_word[$idx++] = "$units{$rem} ";
                }
        }elsif($itNum == 1 ) {
            $rem = $data % 10 ;
            $data = floor($data / 10) ;
            print "Tens $tens{$rem} \n";
            $final_word[$idx++] = "$tens{$rem} " ;
        }else{
            $rem = $data % 10 ;
            $data = floor($data / 10) ;
            print "$units{$rem} $place{$itNum} \n";
            $final_word[$idx++] = "$units{$rem} $place{$itNum} " ;
        }
        $itNum++;
}
my $i;
print "Idx = $idx \n"; 
print @final_word;
print "\n";
for($i=$idx-1;$i>=0;$i--){
        print "$final_word[$i]";
}
