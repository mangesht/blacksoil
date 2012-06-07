use strict;
use Tree;

my $tree = new Tree();
my $element;
my $new_node = new Node();
print "Empty \n";
$tree->addNode("Anil");
$new_node = $tree->getRoot();

$tree->addNode("Mangesh",$new_node);
$tree->addNode("Preeti",$new_node);
$tree->addNode("Rupesh",$new_node);

$new_node = $tree->getNode("Mangesh");
print "Found what \n";
$new_node->print();
$tree->addNode("Gargi",$new_node);
$new_node = $tree->getNode("Gargi");
$tree->addNode("G1",$new_node);
$tree->addNode("G2",$new_node);
$new_node = $tree->getNode("Rupesh");
$tree->addNode("R1",$new_node);
$tree->addNode("R2",$new_node);
$new_node = $tree->getNode("Mangesh");
$new_node = $tree->getNode("G1",$new_node);
print "Found child of Mangesh \n";
$new_node->print();

$tree->print();
