use strict;

#class node;
package Node;
  sub new{
    # sets element value , next pointer to undef
    my ($class) = shift;
    my $self = {
       element => shift,
       _next   =>undef,
       previous =>undef
    };
    print "Adding Node $self->{element} \n";
    bless $self,$class;
    return $self;
  }

sub  print{
    my ($self) = @_;
    printf("%s \n",$self->{element});
  }
1;
#class Stack 
package Stack;
#constructor
sub new{
  my ($class) = shift;
  my $self = {
       top => undef,
       front => undef
  };
    bless $self,$class;
    return $self;
}

sub push{
    my ($self,$elem) = @_;
    my $new_node = new Node($elem); 
    $new_node->{_next} = $self->{top};
    if(!defined($self->{front})){
        $self->{front} = $new_node;
        #print "Front not defined \n";
    }else{
        $self->{top}->{previous} = $new_node;
    }
    $self->{top} = $new_node;
    $self->{top}->print();
}
sub push_front{
    my ($self,$elem) = @_;
    my $new_node = new Node($elem); 
    $new_node->{previous} = $self->{front};
    if(!defined($self->{top})){
        $self->{top} = $new_node;
    }else{
        $self->{front}->{_next} = $new_node;
    }
    $self->{front} = $new_node;
}
sub pop{
    my ($self) = @_;
    my $ret_node = $self->{top}->{element};
    if((defined $self->{top})){
        if($self->{top} == $self->{front}) { 
            #print "Top and Front equal ";
            $self->{front} = undef;
            $self->{top} = undef;
        }else{
            #$self->{top}->{previous} = undef;
            $self->{top}->{_next}->{previous} = undef;
            $self->{top} = $self->{top}->{_next};
        }
    }else{
            print "Failed ";
    }
    return $ret_node;
}
sub pop_front{
    my ($self) = @_;
    my $ret_node = $self->{top}->{element};
    if((defined $self->{top})){
        if($self->{top} == $self->{front}) { 
            #print "Top and Front equal ";
            $self->{front} = undef;
            $self->{top} = undef;
        }else{
            $self->{front}->{previous}->{_next} = undef;
            $self->{front} = $self->{front}->{previous};
        }
    }
    return $ret_node;
}
sub print{
    my ($self) = @_;
    my $elem = $self->{top};
    while (defined ($elem)) {
        #printf("Value = %s \n",$elem->{node}->{element});
        $elem->print();
        $elem = $elem->{_next};
    }
}
sub printQ{
    my ($self) = @_;
    my $elem = $self->{front};
    while (defined ($elem)) {
            #printf("Value = %s \n",$elem->{node}->{element});
        $elem->print();
        $elem = $elem->{previous};
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
