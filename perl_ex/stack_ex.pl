use strict;
use Stack;

my $obj = new Stack();
my $element;
print "Empty \n";
$obj->print();
$obj->push("Mangesh");
$obj->print();
$obj->push("Thakare");
$obj->push("Preeti");
$obj->push("Vidhate");
$obj->push("50");
$obj->push_front("Mr.");
print "After pushs\n";
$obj->print();
print "\nIn Queue format \n";
$obj->printQ();
$element = $obj->pop_front();
while (defined ($element)){
    print "After poping element $element \nIn Stack format\n";
    $obj->print();
    print "\nIn Queue format \n";
    $obj->printQ();
    $element = $obj->pop_front();
}

