#!/usr/bin/perl
# mthakare@cisco.com
# The script takes 2 arguments input_file_name output_file_name 
# default input_file_name is dhl.txt
# Default output_file_name is pktCov.sv
use strict;

my %pythonToSvpl;
$pythonToSvpl{"Arp"} =  "Arp";
#BtagItag
$pythonToSvpl{"Eth"} =  "Eth";
$pythonToSvpl{"Fch"} =  "Fch";
$pythonToSvpl{"InnerEth"} =  "InnerEth";
$pythonToSvpl{"InnerIpv4"} =  "InnerIpv4";
$pythonToSvpl{"InnerIpv6"} =  "InnerIpv6";
$pythonToSvpl{"Ipv4"} =  "Ipv4";
$pythonToSvpl{"Ipv6"} =  "Ipv6";
$pythonToSvpl{"Ipv6ExtnDstnOption2"} =  "Ipv6ExtnDstnOption2";
$pythonToSvpl{"Ipv6ExtnFragment"} =  "Ipv6ExtnFragment";
$pythonToSvpl{"Itag"} =  "Itag";
$pythonToSvpl{"L2Cmd"} =  "L2Cmd";
$pythonToSvpl{"L2Sia"} =  "Sia2";
$pythonToSvpl{"L2_1588"} =  "L2_1588";
$pythonToSvpl{"L3_1588"} =  "L3_1588";
$pythonToSvpl{"MacSec16"} =  "MacSec";
$pythonToSvpl{"MacSec8"} =  "MacSec";
$pythonToSvpl{"Mpls1"} =  "Mpls";
$pythonToSvpl{"Mpls2"} =  "Mpls";
$pythonToSvpl{"Mpls3"} =  "Mpls"; 
$pythonToSvpl{"Rarp"} =  "Rarp";
$pythonToSvpl{"Sap"} =  "Sap";
$pythonToSvpl{"Sil"} =  "Sil";
#SilTag1q 
$pythonToSvpl{"Snap"} =  "Snap"; 
$pythonToSvpl{"Stag"} =  "Stag";
#StagTag1q 
$pythonToSvpl{"Tag1q"} =  "Qtag";
#Tag1qTag1q
$pythonToSvpl{"Tcp"} =  "Tcp";
$pythonToSvpl{"Udp"} =  "Udp";
$pythonToSvpl{"VnTag"} =  "VnTag";


my $inp_fname = "dhl.txt"; 
my $out_fname = "pktCov.sv";
my $sample_fnane = "agsL2IgrSampleFrameTest.sv";
print "Number of Arguments = @ARGV \n";
if (@ARGV > 1 ) { 
    $inp_fname = shift @ARGV ; 
    $out_fname = shift @ARGV;
}elsif (@ARGV > 0 ) { 
    $inp_fname = shift @ARGV ; 
}else{
        print "No File to Process \n";
}


if(!open (MYFH,"<$inp_fname")){
        die "Could not open $inp_fname \n"
}
if(!open(OUTFILE,">$out_fname")){
        die "Could not open $out_fname \n"
}
my $lineNo = 0 ; 
my $line;
my @words;
my $OUTSTR;
my $EACHHDRCOV;
my $binName;
my $transitions;
my %hdrList;


# Start parsing dhl.txt 
while($line=<MYFH>){
        #print "Parsing Line $lineNo \n";
    $lineNo++; 
    chomp($line);
    # Check if Line is valid header line 
    /MangeshThakare/;
    if($line =~ s/'//g){
            #print "mangesh $&";
    }else{
        print "Skipping Line $line\n";
            next;
    }
    #$line =~ s/ //g; # I could have liked to delete all the spaces , but keeping it as headers could be separated by space too
    $line =~ /\[.*\]/;
    $line = $&;
    # Delete [ ] , and extra spaces 
    if($line =~ s/\[//g){
    }else{
        print "Skipping Line $line\n";
            next;
    }

    # Read source sample file and print it to new file

if(!open (SMPFH,"<$sample_fnane")){
        die "Could not open $sample_fnane \n"
}

my $output_fname = "output.sv";
if(!open (OUTFH,">$output_fname")){
        die "Could not open $output_fname \n"
}
    
    my $samp_line;
    while($samp_line=<SMPFH>){
       if($samp_line =~ /PKT_HDR/){
            last;
       }else{
            print OUTFH $samp_line ; 
       }
    }
#    if($& =='') next;
    $line =~ s/\]//g;
    $line =~ s/,/ /g;
    $line =~ s/  */ /g;
#    print "$line \n"; 
#    if($& =='') next;
    #print "After Cleansing \n $line \n";
    #@words = split(/([, ])/,$line);
    @words = split(/([, ])/,$line); # Split based on comma or space . comma we already deleted 
    #print "words = @words \n";
    $binName = "";
    $transitions = "";
    for(my $ii=0;$ii<= $#words;$ii++){
        if($words[$ii] eq ' '){
                # Space is omnipresent. Better to consider it 
                next;
        }
        if($ii==0) {
                $transitions = $transitions ."(";
        }
        if(exists $pythonToSvpl{$words[$ii]}) {
                $hdrList{$words[$ii]} = 1 ; 
                $binName = $binName . $words[$ii];
                if($#words == $ii) { 
                        #$transitions = $transitions ."$words[$ii])";
                    $transitions = $transitions ."$pythonToSvpl{$words[$ii]})";
                }else{
                    $transitions = $transitions . "$pythonToSvpl{$words[$ii]} =>";
                }
        }else{
               print "Mapping for $words[$ii] does not exist. Skipping it\n";
        }
    }

    $OUTSTR = $OUTSTR . "    bins $binName"."Trans"." = ". $transitions . ";\n";
    last;
}
my $preamble; 
$preamble = "covergroup hdrTransitions;\n" ; 
$preamble = $preamble . "coverpoint currentHdr {\n";
$OUTSTR =  $preamble . $OUTSTR ; 
$OUTSTR = $OUTSTR . "}\nendgroup\n" ;


$EACHHDRCOV = "\ncovergroup covEachHdr;\n";
$EACHHDRCOV = $EACHHDRCOV . "coverpoint currentHdr {\n";

for my $hdrName(keys %hdrList){
        print "$hdrName\n";
$EACHHDRCOV = $EACHHDRCOV . "    bins $pythonToSvpl{$hdrName}CovBin = { $pythonToSvpl{$hdrName} } ;\n";
}
$EACHHDRCOV = $EACHHDRCOV . "}\nendgroup\n";


#print $OUTSTR;
print OUTFILE "class PktCoverGroup;\n";
print OUTFILE "\n";
print OUTFILE "PktEncapTypes currentHdr;\n";
print OUTFILE "\n";
print OUTFILE "    extern function new(string name);\n";
print OUTFILE "    extern function void dataEvent();\n";



print OUTFILE $EACHHDRCOV;
print OUTFILE $OUTSTR;
print OUTFILE "\n";
print OUTFILE "endclass \n";
print OUTFILE "\n";
print OUTFILE "function PktCoverGroup::new(string name);\n";
print OUTFILE "    covEachHdr = new ; \n";
print OUTFILE "    hdrTransitions = new ; \n";

print OUTFILE "endfunction  \n";
print OUTFILE "function void PktCoverGroup::dataEvent();\n";
#    $display("PktCoverGroup Sampled %s \n",hdrName);
#    currentHdr = strToPktEncapEnum[hdrName]; 
print OUTFILE "     // Make Sure that currentHdr is assigned before sampling \n";
print OUTFILE "    covEachHdr.sample();\n";
print OUTFILE "    hdrTransitions.sample();\n";
print OUTFILE "endfunction  \n";

print "Headers\n";
#for my $hdrName(keys %hdrList){
#        print "$hdrName\n";
#}
