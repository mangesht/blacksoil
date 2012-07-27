#!/usr/bin/perl
use strict;
my $flist_name ; 
my $line ; 
my $inp_fname;
my $cov_fname = "sample.el";
my @words;

if(!open (COV_FILE,"<$cov_fname")){
    die "Could not open $cov_fname \n";
}else{
    print "Processing $cov_fname \n" ;
}
while($line=<COV_FILE>){
   #chomp($line);
   if($line ne "") { 
       ## $keyword = shift @words ; 
   } else { 
       next ;  
   }
   @words = split(/ /,$line);
#   s/"//g;
    if($words[0] eq "FILE:") {
           print ("\nFileName = $words[1]\n"); 
    }elsif($words[0] eq "Line") {
           print ("\nLine Number = $words[1]\n"); 

   }else{
           print " OtherWise  $words[0] ";
   }

}
