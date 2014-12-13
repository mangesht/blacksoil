#!/usr/local/bin/perl
use strict;

my %coins = ("Quarter", 25, "Dime", 10, "Nickel", 5);
my %status = ("Mangesh" , 07 , "Rupesh" , 02 );
my $k;
my $v;
my %status_0 = ("Mangesh" , 07 , "Rupesh" , 02 );
my %status_1 = ("Mangesh" , 17 , "Rupesh" , 12 );
my %status_2 = ("Mangesh" , 27 , "Rupesh" , 22 );
my %h_o_h;


print "\nJust print status hash \n";
print "\n";
$coins{"Status"} = %status;
print "Just print hash \n";
print %coins;
$coins{"Rupee"}=100;
$coins{"user_def"}++;
$coins{"user_def"}++;

print "\nUsing While \n";
while(($k,$v) = each %coins ){
        print "Key = $k\t";
        print "value = $v or $coins{$k}\n";
}

print "\nSorting \n";
my %s_coins = sort %coins;
while(($k,$v) = each %s_coins ){
        print "Key = $k\t";
        print "value = $v or $s_coins{$k}\n";
}

print"\nDeleting an element \n";

delete ($coins{"user_def"});
while(($k,$v) = each %coins ){
        print "Key = $k\t";
        print "value = $v or $coins{$k}\n";
}


#$h_o_h{mash} = %status_0;
#$h_o_h{m1} = %status_1;
#$h_o_h{m2} = %status_2;
#%h_o_h = (status_0,status_1);
$h_o_h{"mthakare"}{"coded"} = 25 ;
$h_o_h{"mthakare"}{"done"} = 5 ;
$h_o_h{"mthakare"}{"started"} = 3 ;

$h_o_h{"suleesh"}{"coded"} = 125 ;
$h_o_h{"suleesh"}{"done"} = 15 ;
$h_o_h{"suleesh"}{"started"} = 13 ;
my $value ; 
my $role ; 
print "Hash of hashes \n";
for $value(keys %h_o_h) {
    print "value = $value :\n";
#    print "$h_o_h{$value} \n";
    for $role (keys %{$h_o_h{$value}}) {
         print "Role = $role = $h_o_h{$value}{$role} \t"
    }
    print "\n";
}

print "Hash of hashes Family Tree \n";
my @mangesh = ("Heamant","sharad","shishir","varsha","grishma");
my %HoH = (
    flintstones => {
        husband   => "fred",
        pal       => "barney",
    },
    jetsons => {
        husband   => "george",
        wife      => "jane",
        "his boy" => "elroy",  # Key quotes needed.
    },
    simpsons => {
        husband   => "homer",
        wife      => "marge",
        kid       => "bart",
    },
    thakare => [@mangesh] ,
);

print "Special access ";
for $value(keys %HoH) {
    print "Value = $value :\n";
    if($value ne  "thakare") { 
    for $role (keys %{$HoH{$value}}) {
         print "$role = $HoH{$value}{$role} \n"
    }
    }else{
        my $m;
        my @man=@{$HoH{$value}};
        print "Skipping it $value \n";       
        foreach $m (@man){
             print "$m \n";
        }
    }
}
my %hoa;

my @line1 = ("Mangesh","Thakare","anilrao");
my @line2 = ("Rupesh","Thakare");
my @line3 = ("Preeti","Vidhate");
print "Line 1 @line1 \n";
print "Line 2 @line2 \n";
print "Line 3 @line3 \n";

$hoa{"line1"} = [@line1];
$hoa{"line1"}->[3] = "Rupesh";
$hoa{"line4"} = [("Sagar")];
my @line_3 = @{$hoa{"line1"}};
print "hash Line 1 " ;print @{$hoa{"line1"}};
print "\nline 3 \n";
print @line_3;
print "Line 4 - "; print "@{$hoa{qq(line4)}}\n";
if(defined($hoa{"mangesh"})){
    print "hoa of mangesh is defined \n" ;
}else{
    print "hoa of mangesh is NOT defined \n" ;
}

if(defined($hoa{"line1"})){
    print "Hoa of line1 is defined \n";
}else {
    print "Hoa of line1 is NOT defined \n";
}
