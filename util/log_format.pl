#!/router/bin/perl
use strict;

#print " @ARGV; \n";
my $str;
my $line ; 
my $fname;
my $outfilename = "local.log";
my $pkt_num = 0; 
my $ref_pkt_num = 0; 
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
my @ref_str;
my @rtl_str;
my $ref_str_len;
my $rtl_str_len;

foreach $line(<INFILE>){
    my $wr_done; 
    $_ = $line ; 
    if(/Ref Model Pkt : [0-9a-f]*/){
        #print "String Found \n";
        $_ = $&;
        if(/:  *[0-9a-f]+/){
            $_ = $&;
            s/[: ]*//g;
            #print "$_ \n"
            $ref_pkt_num++;
            print OUTFILE "Ref Model pkt $ref_pkt_num\n";
            @ref_str = split(//,$_);
            &format_str ($_);
            
        }
        $wr_done  = 1 ; 
    } elsif(/ref\. model pkt : *[0-9a-f]*/){
        #print "String Found \n";
        print OUTFILE "$`\n";
        $_ = $&;
        if(/:  *[0-9a-f]+/){
            $_ = $&;
            s/[: ]*//g;
            #print "$_ \n"
            print OUTFILE "ref. model pkt \n";
            @ref_str = split(//,$_);
            &format_str ($_);
            $ref_pkt_num++;
        }
        $wr_done  = 1 ; 
    }elsif(/^svpl: eth\[0\]: da/){
       $pkt_num++;
        print OUTFILE "GENERATED PACKET NUM $pkt_num \n";
    }elsif(/\/auto\/gsg-/){
        # Replace long long file names 
        $line =~ s/\/auto\/gsg-.*\///g;
    }elsif(/on gsGlobalLogger\(gsGlobalLoggerInst\)/){
        $line =~ s/on gsGlobalLogger\(gsGlobalLoggerInst\)//g;
    }
    $_ = $line ; 
    if(/RTL Pkt : [0-9a-f]*/){
        $_ = $&;
        #print "RTL String Found \n";
        if(/:  *[0-9a-f]+/){
            $_ = $&;
            s/[: ]*//g;
            #print "$_ \n"
            print OUTFILE "RTL pkt \n";
            @rtl_str = split(//,$_);
            &format_str ($_);
        }
        $wr_done  = 1 ; 
        # Compare the 2 vectors here 
        $ref_str_len = @ref_str;
        $rtl_str_len = @rtl_str;
        print "Len = $ref_str_len \n";
        if($ref_str_len != $rtl_str_len ) {
            printf(OUTFILE "Length of the streams do not match. Ref = %d  RTL = %d  \n",$ref_str_len/2,$rtl_str_len/2);
        }
        my $i;
        for($i=0;$i<=$ref_str_len;$i++){
            if($ref_str[$i] != $rtl_str[$i] ){
                printf (OUTFILE "Mismatch at location %d \n",($i+2)/2);
                last;
            }
        }
    }elsif(/RTL pkt : [0-9a-f]*/){
        $_ = $&;
        #print "RTL String Found \n";
        if(/:  *[0-9a-f]+/){
            $_ = $&;
            s/[: ]*//g;
            #print "$_ \n"
            print OUTFILE "RTL pkt \n";
            @rtl_str = split(//,$_);
            &format_str ($_);
        }
        $wr_done  = 1 ; 
        # Compare the 2 vectors here 
    }
    if($wr_done == 0) {
        print OUTFILE  "$line"
    } 
}

#print @ref_str;
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
