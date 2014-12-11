#!/usr/local/bin/perl
use strict;
use Parse;
my $obj = new Parse("exp.txt");
my $token;
my $i;


$obj->{name} = "Mangesh";
print "Name = $obj->{name} \n";
# Loop starts here 
do{
$token = $obj->get_token();
print "Token $i = $token \n";
if(!($token cmp "include")){
    my $fname="";
    print "\t Include token \n";
    $token = $obj->get_token();
    if (!($token cmp '"')){
       print "\t\tQuote \n";
    }
    do {
        $token = $obj->get_token();
        if (!($token cmp '"')){
           
        }else{
            $fname = $fname . $token; 
        }
    }while($token cmp '"');
    print "Include file is $fname \n";
    # Start parsing this file 
    my $incObj = new Parse($fname);
    
    do{
        $token = $incObj->get_token();
        print "TokenI $i = $token \n";
    }while($token ne "__EOFPARSE");
    $token = "FG";
    print "Inc Name = $incObj->{name} \n";
    print " Name = $obj->{name} \n";
}
}while($token ne "__EOFPARSE");

