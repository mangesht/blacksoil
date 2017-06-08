#!/usr/local/bin/perl
use strict;

my $f1 , my $f2 ;
if(scalar @ARGV > 1 ) { 
    $f1 = shift @ARGV ;
    $f2 = shift @ARGV ;
} else { 
die ;
}  

print "Performing $f1 - $f2 \n"; 

if(!open(F1,$f1)) { 
      die "Can't open $f1 \n";
}
if(!open(F2,$f2)) { 
      die "Can't open $f2 \n";
}
my $line; 
my %s1;
foreach $line(<F1>){
    chomp($line);
    $s1{$line} = 1; 
}
my @diff; 
foreach $line(<F2>){
    chomp($line);
    if(defined($s1{$line})) { 
        delete $s1{$line};
    } else { 
        push @diff , $line;  
    }  
}

close F1;
close F2; 
print " From $f2 \n"; 
foreach $line(@diff){
    print ("$line\n"); 
}
my $key;
print "From $f1 \n"; 

for $key(keys %s1) { 
    print "$key\n";
} 

