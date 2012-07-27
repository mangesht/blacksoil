#!/usr/local/bin/perl

# The utility takes in 2 paramters 
# First is the name of coverage disable file eg. cov_disable_pp.tcl 
# Second one is the path of new database . New path should atleast be provided till design folder eg. /work/misano/mthakare/oct13run/design or /work/misano/mthakare/oct13run/design/asics/misano/modules ....
# Second paramter is optional. By default current working directory is taken as destination folder 

# It creates new file with the extension of .new over the input filename e.g. cov_disable_pp.tcl.new 
# Error log is created in error.log 

use strict;
use Cwd;

my $cov_fname;
my $inp_new_path;
my $o_rtl_fname;
my $n_rtl_fname;
my $line ; 
my $o_path;
my $n_path;

$cov_fname = "cov_disable_fe.tcl";
# $inp_new_path = "/work/ins068/mthakare/mis12oct/design/asics/misano/modules/fe/dv";
$inp_new_path = getcwd; 
if(@ARGV>1){
    $cov_fname = shift @ARGV;
    $inp_new_path = shift @ARGV;
}elsif(@ARGV >0){
    $cov_fname = shift @ARGV;
}else{
    print "Enter the the name of coverage disable file ";
    $cov_fname = <STDIN>;
}
$_ = $inp_new_path;
/^.*design/;

$n_path = $&; 
my @words ;
my $o_line_num;
my $n_line_num;
my $new_cov_fname;

$_ = $cov_fname;
s/\./_new\./g;
$new_cov_fname = $_ ; 
# $new_cov_fname = $cov_fname . ".new"; 
# print "New Coverage file = $new_cov_fname \n"; 

if(!open (COV_FILE,"<$cov_fname")){
    die "Could not open $cov_fname \n";
}else{
    print "Processing $cov_fname \n" ;
}

if(!open(N_COV_FILE,">$new_cov_fname")) {
    die "Could not open $new_cov_fname \n"; 
}

if(!open(ERROR_FILE,">error.log")){
    die "Could not open error.log. Please check for write permission or disk full \n";
} 

my $last_rtl_file;
my $offset = 0 ; 
while($line=<COV_FILE>){
   #chomp($line);
   if($line ne "") { 
       ## $keyword = shift @words ; 
   } else { 
       next ;  
   }
   @words = split(/ /,$line);
   $o_rtl_fname = $words[3];
   $o_line_num = $words[2];
   $_ = $o_rtl_fname;
   s/"//g;
   $o_rtl_fname = $_;
   #print "RTL file processing = $o_rtl_fname line = $o_line_num\n";
   if(!open(O_RTL_FILE,"<$o_rtl_fname")){
        die "Could not open rtl file = $o_rtl_fname \n";
   }else{
   }
   # Get the line that is disabled 
   my $i;
   my $o_dis_str;
   for($i=0;$i<$o_line_num;$i++){
       $o_dis_str=<O_RTL_FILE>;
   }
   chomp($o_dis_str);
   close O_RTL_FILE;
   # print "disabled Line num = $o_line_num Line = $o_dis_str \n";
   $_ = $o_dis_str ;
   # Remove blank charactors 
   s/ //g;
   s/\t//g;
   $o_dis_str = $_; 
   # print "disabled Line num = $o_line_num Line = $o_dis_str \n";
   # Search the same line in the new code 
   $_ = $o_rtl_fname;
   /^.*design/;
   $o_path=$&;
   $_ = $o_rtl_fname;
   s/$o_path/$n_path/g;
   $n_rtl_fname = $_;
   # print "new path = $_ \n";
   
   #  Search new file and find out matching locations
   my @line_match;
   if(!open(N_RTL_FILE,"<$n_rtl_fname")){
        die " Could not open RTL file $n_rtl_fname \n";
   }
   if($last_rtl_file ne $n_rtl_fname) {
      $offset = 0 ;
      # print "offset mde 0 $last_rtl_file $n_rtl_fname \n";
   }
   $last_rtl_file = $n_rtl_fname;
   my $r_line;
   my $idx;
   $idx=1;
   while($r_line=<N_RTL_FILE>){
    chomp($r_line);
    $_ = $r_line; 
    s/ //g;
    s/\t//g;
    $r_line = $_;
    if($r_line eq $o_dis_str){
       # print "Matched \n";
       $line_match[$idx] = 1 ;
    }else{
       ##print " line $idx No match $r_line $o_dis_str\n";
       $line_match[$idx] = 0 ;
    }
    $idx++;
   }
   # print @line_match;
   
   # Start matching with new vectors
   my $matched_line_num = 0;
   my $deviation = 0 ; 
   while(($o_line_num + $offset + $deviation < $idx) or ($o_line_num + $offset- $deviation > 0)){
        if($o_line_num+ $offset+$deviation <= $idx ) {
            if($line_match[$o_line_num+ $offset+$deviation] == 1 ){
                # Nearest Match found 
                $matched_line_num = $o_line_num+ $offset+$deviation;
                last;
            }
        }
        if($o_line_num + $offset- $deviation > 0 ) { 
            if($line_match[$o_line_num+ $offset-$deviation] == 1 ){
                # Nearest Match found 
                $matched_line_num = $o_line_num+ $offset-$deviation;
                last;
            }
        } 
        $deviation++;
   }
   if($matched_line_num == 0 ) { 
        print ERROR_FILE "Error match not found for the line $o_dis_str \n";
        print N_COV_FILE  $line ; 

   }else{
        # print "Match found on Line $matched_line_num \n";
        # print N_COV_FILE  "1 $words[0] $words[1] $matched_line_num  $n_rtl_fname" ; 
        my $word_len;
        my $new_offset ; 
        $new_offset = $matched_line_num - $o_line_num ;
        $offset = $new_offset; 
        # print "Offset = $offset $deviation \n";
        $word_len = $#words;
        for($i=0;$i<=$word_len;$i++){
           if($i == 2 ) {
                print N_COV_FILE "$matched_line_num ";
           } elsif($i==3){
                print N_COV_FILE '"' . "$n_rtl_fname" .'" ';
           } elsif($i==$word_len){
              print N_COV_FILE "$words[$i]";
           }else{
              print N_COV_FILE "$words[$i] ";
           }
        }
        if($deviation > 20 ) { 
            print ERROR_FILE "Code modified a lot for $o_rtl_fname Line $o_line_num , please have a look at new file \n"
        } 
        #print N_COV_FILE "\n";
   }
}
print "New coverage disable file is created as $new_cov_fname . Check error.log for errors \n";
