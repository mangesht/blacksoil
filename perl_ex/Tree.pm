use strict;

#class node;
package Node;
  sub new{
    # sets element value , next pointer to undef
    my ($class,$elem) = @_;
    my $self = {
       element => $elem,
       next_node   =>undef,
       nodes    => undef
    };
    bless $self,$class;
    #print "Adding Node $elem AND $self->{element} \n";
    return $self;
  }

sub displayNode{
    my ($self,$level) = @_;
    my $i ; 
    my $k;
    for($i=0;$i<=$level;$i++){
        printf "  ";
    }
    $self->print();
    # Get the next Nodes and print them
    foreach $k (@{$self->{nodes}}){
            #bless $k,$self;
            $k->displayNode($level+1);
    }
}
sub get_childen_count{
    # Returns the number of childen the node has 
    my ($self) = @_;
    my $c_count;
    if(defined $self->{nodes}){
        $c_count = @{$self->{nodes}};
    }else { 
        $c_count = 0;
    }
    return $c_count;
}


sub find_it{
    my ($self,$search_str) = @_;
    my $res= undef;
    my $k;
    if($self->{element} eq $search_str) {
          $res = $self;
    }else{
        foreach $k (@{$self->{nodes}}){
            $res = $k->find_it($search_str);
            if(defined $res) {
                last;
            } 
        }
    }
    return $res;
}

sub print{
    my ($self) = @_;
    printf("%s \n",$self->{element});
  }
1;
#class Stack 
package Tree;
#constructor
sub new{
  my ($class) = shift;
  my $self = {
       root => undef,
  };
    bless $self,$class;
    return $self;
}

sub addNode{
    # Creates a new node 
    # Attaches it to the tree as child of node
    my ($self,$elem,$node) = @_;
    #print "Command to add $elem \n";
    my $new_node = new Node($elem); 
    if(!defined($self->{root})){
            #print "Adding to root \n";
        $self->{root} = $new_node;
    }else{
        my $len = $node->get_childen_count();
        #print "Number of children = $len \n";
        $node->{nodes}[$len]=$new_node;
    }
}

sub getRoot{
    my ($self) = @_;
    return $self->{root};
}
sub getNode{
    # Takes 2 parameters string_to_search , node from where to begin the search
    # By default root is taken
    my ($self,$search_str,$node) = @_;
    if(!defined $node){
            $node = $self->{root};
    }
    my $res = $node->find_it($search_str);
    return $res;
}


sub print{
    my ($self) = @_;
    print "Displaying the tree \n ";
    my $elem = $self->{root};
    if (defined ($elem)) {
            $elem->displayNode(0);
    }
}


1;
package leaf;
  sub new{
    # sets 
    my ($class) = shift;
    my $self = {
       element => undef,
       leaf_ptr => undef
    };
    bless $self,$class;
    return $self;
}
1;

