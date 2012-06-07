my $sec;
my $min;
my $hour;
my $mday;
my $mon;
my $year;
my $wday;
my $yday;
my $isdst;
#system("dir > c:\\personal\\utility\\perl_ex\\abc.txt");
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;

print "$mday - $mon - $year \n";



