use strict;
use Getopt::Long;

my $myName;
GetOptions(
        'myName=s' => \$myName);

if(defined($myName)){
        print "Defined name = $myName \n";
}else{
        print "Not defined names \n";
}
