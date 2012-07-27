#!/router/bin/perl
use strict;
my @stat_key = ("NOT_STARTED","STARTED","CODED","DONE");
my @stat_values = (0           ,0        ,0      ,0     );
my $flist_name;
my $line ;
my $inp_fname;

my @attr_name;
my @author;
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
if(@ARGV>1){
    $flist_name = shift @ARGV;
    $report_filename = shift @ARGV;
}elsif(@ARGV >0){
    $flist_name = shift @ARGV;
} else{
    print "Please enter the report file name \n";
    $flist_name = "attrList.txt";
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
    $report_filename = "$`.csv" ;
    $cur_attr_fname = $`;
    print "Output File = $report_filename \n";
    
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
            }
        } elsif ($keyword eq "AUTHOR") { 
            if($testcase_parse == 0 ) { &my_error("Parsing error for $keyword"); } else { 
                $author[$index] = join (' ',@words) ; 
            }
        } elsif ($keyword eq "TESTWRITER") { 
            if($testcase_parse == 0 ) {  &my_error("Parsing error for $keyword"); }else{ 
                $test_writer[$index] = join (' ',@words) ; 
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
    
    my $out_mode_wiki = 0 ; 
    if($out_mode_wiki == 1 ) {
        print OUTFILE "|| $cur_attr_fname ||\n";
        print OUTFILE "||Sr.No.||Attribute || Author || Test Writer|| Status ||Start Date || End Date ||\n";
        for(my $i=0;$i<$index;$i++){
            my $j = $i +1 ;
            print OUTFILE "| $j | $attr_name[$i]| $author[$i]| $test_writer[$i]| $status[$i]| $start_date[$i]| $end_date[$i]|\n";
        }
    } else {
        print OUTFILE "Attribute , Author , Test Writer,Status,Start Date,End Date \n";
        for(my $i=0;$i<$index;$i++){
            print OUTFILE "$attr_name[$i],$author[$i],$test_writer[$i],$status[$i],$start_date[$i],$end_date[$i]\n";
        }
    }
    &myprint_stat(1);
    printf(OUTFILE "TOTAL \t %d\n",$index);
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
        print OUTFILE "@stat_key[$i] \t @stat_values[$i]\n";
    }
}

sub my_error($_) {
    my $err_mess= $_  ; 
    if(!open(ERRFILE,">>error.log")){
        die "Could not open error.log \n";
    }
    printf(ERRFILE "ERROR: %s \n",$err_mess);
}
