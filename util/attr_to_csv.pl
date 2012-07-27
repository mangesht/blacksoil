#!/usr/bin/perl
use strict;
###
# Author  : Mangesh Thakare (mthakare@cisco.com)
# Usage   : attr_to_csv.pl outputMode AttributeList 
# Example : attr_to_csv.pl 0 attrList.txt 
# outputMode : 0 - CSV format 
#              1  - Wiki format
#            Default is 0 
# AttributeList  : The script picks up the attributes list from a file named . Default is attrList.txt

#  
###
my @stat_key = ("NOT_STARTED","STARTED","CODED","DONE");
my @stat_values = (0           ,0        ,0      ,0     );
my $flist_name;
my $line ;
my $inp_fname;

my @attr_name;
my @author;
my @priority;
my @test_name;
my @test_writer;
my @start_date;
my @status;
my @rate;
my @end_date;
my @time;
my $report_filename;

my $index=0;
my @words;
my $cur_attr_fname;
my $testcase_parse = 0; 
$report_filename = "my_report.csv";
$flist_name = "attrList.txt";
my $out_mode_wiki = 0 ; 
if(@ARGV>1){
    $out_mode_wiki = shift @ARGV;
    $flist_name = shift @ARGV;
}elsif(@ARGV >0){
    $out_mode_wiki = shift @ARGV;
} else{
    print "Please enter the report file name \n";
}
if(!open(FILELIST,"<$flist_name")){
    die "Die Could not open $flist_name for reading \n";
}

if(!open(ERRFILE,">error.log")){
    die "Die Could not open error.log \n";
}

while($inp_fname=<FILELIST>){
    print "Processing $inp_fname \n";
    if(!open(MYFH,"<$inp_fname")){
        print "Could not open $inp_fname \n";
        next;
    }
    
    $inp_fname =~ /\..*/;
    $report_filename = $out_mode_wiki == 0 ? "$`.csv" : "$`.wiki";
    $cur_attr_fname = $`;
    print "Output File = $report_filename \n";
    
    my $missingField=0;
    my $fieldsSeen=0;
    while($line=<MYFH>){
        my $keyword;
        chomp($line);
        $_ = $line;
        s/,/ /g;
        s/:/ /g;
        s/\x0D//g;
        $line = $_;
        if(/\x0D/){
            print "Ctrl M found \n";
        }
        @words = split(/ /,$line);
        if($line ne ""){
            $keyword = shift @words;
        }else{
            # ;
            next;
        }
        #print  " Keyword = $keyword\n";
        if($keyword eq "ATTRIBUTE"){
            if($testcase_parse == 1 ) { my_error("Parsing error for $keyword"); } else { 
                $testcase_parse = 1 ; 
                #print "Words = @words\n";
                $attr_name[$index] = join (' ',@words);
                $missingField =  $missingField + 1;
                $fieldsSeen++;
            }
        }elsif($keyword eq "PRIORITY"){
            if($testcase_parse == 0 ) { &my_error("Parsing error for $keyword"); } else { 
                $priority[$index] = join (' ',@words) ; 
            }
        }elsif($keyword eq "TESTNAME"){
            if($testcase_parse == 0 ) { &my_error("Parsing error for $keyword"); } else { 
                $test_name[$index] = join (' ',@words) ; 
                $fieldsSeen++;
                $missingField =  $missingField + 10;
            }

        } elsif ($keyword eq "AUTHOR") { 
            if($testcase_parse == 0 ) { &my_error("Parsing error for $keyword"); } else { 
                $author[$index] = join (' ',@words) ; 
                $missingField =  $missingField + 100;
                $fieldsSeen++;
            }
        } elsif ($keyword eq "TESTWRITER") { 
            if($testcase_parse == 0 ) {  &my_error("Parsing error for $keyword"); }else{ 
                $test_writer[$index] = join (' ',@words) ; 
                $missingField =  $missingField + 1000;
                $fieldsSeen++;
            }
        } elsif ($keyword eq "START_DATE") { 
            if($testcase_parse == 0 ) {  &my_error("Parsing error for $keyword");}else {  
                $start_date[$index] = join (' ',@words) ; 
            }
        } elsif ($keyword eq "STATUS") { 
            if($testcase_parse == 0 ) {  &my_error("Parsing error for $keyword"); } else {  
                $status[$index] = join (' ',@words) ;
                &analyze_stat (@words);
                $index++;
                $testcase_parse = 0; 
                if($fieldsSeen !=  4 ) { 
                        print "ERROR : Some field missing in attribute $test_name[$index-1] Index = $index \n";
                        print "MIssing Field = ATNAME TESTNAME AUTH TESTWRITER $missingField \n";
                }
                $fieldsSeen =0;
                $missingField = 0; 
            }
        } elsif ($keyword eq "Rate:") { 
            $rate[$index] = join (' ',@words) ; 
            if($testcase_parse == 0 )  { &my_error("Parsing error for $keyword");}
        } elsif($keyword eq "END_DATE"){
            $end_date[$index] =  join (' ',@words);
            if($testcase_parse == 0 ) {  &my_error("Parsing error for $keyword");} 
        }
    }
    
    if(!open(OUTFILE,">$report_filename")){
        die " Die Could not $report_filename \n";
    }
    
    if($out_mode_wiki == 1 ) {
        print OUTFILE "|| $cur_attr_fname ||\n";
        print OUTFILE "||Sr.No.||Attribute ||Test Name || Author || Test Writer|| Status ||Start Date || End Date ||\n";
        for(my $i=0;$i<$index;$i++){
            my $j = $i +1 ;
            print OUTFILE "| $j | $attr_name[$i]| $test_name[$i] | $author[$i]| $test_writer[$i]| $status[$i]| $start_date[$i]| $end_date[$i]|\n";
        }
    } else {
        # Excel format 
        print OUTFILE "Sr.No.,Attribute ,Test Name ,Author , Test Writer,Status,Start Date,End Date \n";
        for(my $i=0;$i<$index;$i++){
            my $j = $i +1 ;
            print OUTFILE "$j,$attr_name[$i],$test_name[$i],$author[$i],$test_writer[$i],$status[$i],$start_date[$i],$end_date[$i]\n";
        }
    }
    &myprint_stat(1);
    close OUTFILE;
}

sub analyze_stat (@words){
    my $keyword = "";
    while($keyword eq ""){ 
        $keyword = shift @words;
    }
    
    my $len = @words;
    #print "KeyWord = $keyword  len = $len \n";
    for(my $i=0;$i<@stat_key;$i++){
        if($keyword eq @stat_key[$i]){
            @stat_values[$i]++;
            last;
        }
    }
}

sub myprint_stat($dummy){
    for(my $i=0;$i<@stat_key;$i++){
        print OUTFILE ",@stat_key[$i] ,@stat_values[$i]\n";
    }
    printf(OUTFILE ",TOTAL , %d\n",$index);
}

sub my_error($_) {
    my $err_mess= $_  ; 
    if(!open(ERRFILE,">>error.log")){
        die "Could not open error.log \n";
    }
    printf(ERRFILE "ERROR: %s \n",$err_mess);
}
