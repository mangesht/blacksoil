#!
use strict;
my $arg_1 = "sample.data";
my $arg_1 = "dhl.txt";

print "Number of Arguments = @ARGV \n";
if (@ARGV > 0 ) { 
    $arg_1 = shift @ARGV ; 
}else{
        print "No File to Process \n";
}

my $inp_fname = $arg_1; 

if(!open (MYFH,"<$inp_fname")){
        die "Could not open $inp_fname \n"
}
my $lineNo = 0 ; 
my $line;
my @words;
my $OUTSTR;
my $binName;
my $transitions;
my %hdrList;
while($line=<MYFH>){
    print "Parsing Line $lineNo \n";
    $lineNo++; 
    chomp($line);
    $line =~ s/'//g;
    $line =~ s/ //g;
    $line =~ s/\[//g;
    $line =~ s/\]//g;
    #print "After Cleansing \n $line \n";
    @words = split(/,/,$line);
    #print "words = @words \n";
    $binName = "";
    $transitions = "";
    for(my $ii=0;$ii<= $#words;$ii++){
        if($ii==0) {
                $transitions = $transitions ."(";
        }
        $binName = $binName . $words[$ii];
        $hdrList{$words[$ii]} = 1 ; 
        if($#words == $ii) { 
            $transitions = $transitions ."$words[$ii])";
        }else{
            $transitions = $transitions . "$words[$ii] =>";
        }
    }
    $OUTSTR = $OUTSTR . "    bins $binName"."Trans"." = ". $transitions . ";\n";
}
my $preamble; 
$preamble = "covergroup hdrTransitions;\n" ; 
$preamble = $preamble . "coverpoint tempHdr {\n";
$OUTSTR =  $preamble . $OUTSTR ; 
$OUTSTR = $OUTSTR . "}\nendgroup\n" ;
print $OUTSTR;


for my $hdrName(keys %hdrList){
        print "$hdrName\n";
}
