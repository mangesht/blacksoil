#!/router/bin/perl
use strict;

#print " @ARGV; \n";
my $str;
my $line ; 
my $fname;
my $outfilename = "local.log";
if(@ARGV < 1 ) {
    #$str="Mangesh1234567890abcdteufhfj";
    die "FileName not valid\n";
} else {
    $fname = shift @ARGV;
}

if(!open(INFILE,$fname)){
    die "Could not open $fname for reading \n";
} 

if(!open(OUTFILE,">$outfilename")){
    die "Could not open %outfilename for writing \n";
} 

foreach $line(<INFILE>){
    my $wr_done; 
    $_ = $line ; 
    if(/Ref Model Pkt : [0-9a-f]*/){
        #print "String Found \n";
        if(/:  *[0-9a-f]+/){
            $_ = $&;
            s/[: ]*//g;
            #print "$_ \n"
            print OUTFILE "Ref Model pkt \n";
            &format_str ($_);
        }
        $wr_done  = 1 ; 
    }
    $_ = $line ; 
    if(/RTL Pkt : [0-9a-f]*/){
        #print "RTL String Found \n";
        if(/:  *[0-9a-f]+/){
            $_ = $&;
            s/[: ]*//g;
            #print "$_ \n"
            print OUTFILE "RTL pkt \n";
            &format_str ($_);
        }
        $wr_done  = 1 ; 
    }
    if($wr_done == 0) {
        print OUTFILE  "$line"
    } 
}
#    print "Before call $str \n";
#    &format_str($str) ;


# Function definitions 
sub format_str(@) {
    
    my $str =shift @_ ; 
    #print "Inside call \n";
    my $i;
    my @chars = split(//,$str);
    
    my $len = @chars;
    
    #print "len = $len \n";
    
    for($i=0;$i<$len;$i++){
        if(($i)%2 == 0){
            if(( $i)%16 == 0){
                printf(OUTFILE  "\n %d\t",$i/2);
            } else {
                print OUTFILE  " ";
            }
        }
        print OUTFILE   "@chars[$i]";
    }
    
    print OUTFILE  "\n";
}
