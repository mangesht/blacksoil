#!/router/bin/perl
use strict;

my $tcase_name ;
if(@ARGV > 0 ) { 
    $tcase_name = shift @ARGV;
}
my $outfile = "temp.sv";
$_ = $tcase_name;
    s/UpsAgsIgr/AgsL3Igr/g;   
    s/upsAgsIgr/agsL3Igr/g;   
$outfile = $_ ; 
$outfile = "temp.sv";
print "Testcasne Name 0 $tcase_name \n Outfile = $outfile \n";
if(!open(TCASEFILE,"<$tcase_name")){
    die "Could not open $tcase_name \n";
}
if(!open(OUTFILE,">$outfile")){
    die "Could not open $outfile \n";
}
my $line ; 
my $testcase_name;
my $scenario_name;

while($line=<TCASEFILE>){
    print "$line \n";
    $_ = $line;
    if(/GS_DEFINE_TEST_AND_ENV/){
        $_ = $line;
       /\(\ *\w\w*,/;
       $testcase_name = $&;
        print "1 Testcase Name =$testcase_name\n"; 
        $_ = $&;
        s/\(//g;
        s/ //g;
        s/,//g;
       $testcase_name = $_;
    }elsif(/^ *extends.*Scenario/){
        $_ = $line ; 
        /\( *\w\w*\)/;
        $_ = $& ; 
        s/\(//g;
        s/\)//g;
        $scenario_name = $_ ; 
    }
}
close TCASEFILE;
print "Scenario Name =  $scenario_name \n";

print "Testcase Name =$testcase_name\n"; 
if(!open(TCASEFILE,"<$tcase_name")){
    die "Could not open $tcase_name \n";
}
$testcase_name =~ s/UpsAgsIgr/AgsL3Igr/g;   
print "Testcase Name =$testcase_name\n"; 

my $new_scenario_name = join "", $testcase_name , "Scenario";
while($line=<TCASEFILE>){
    $_ = $line;  
    s/UpsAgsIgr/AgsL3Igr/g;   
    s/upsAgsIgr/agsL3Igr/g;   
    s/$scenario_name/$new_scenario_name/;
    print OUTFILE $_ ;
    if(/GS_DEFINE_TEST_AND_ENV/){
        print OUTFILE "`AGS_DEFINE_CNSTR_SCENARIO($testcase_name,$scenario_name)";
    }
}
print "New File created $outfile \n";
close OUTFILE;
close TCASEFILE;
