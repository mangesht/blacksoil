#!/usr/local/bin/perl
use strict;
#class Person
package Person;


#constructor
sub new {
    my ($class) = shift;
    my $self = {
        _firstName => shift,
        _lastName  => shift,
        _ssn       => shift,
        _address   => shift,
        _next      =>undef
    };
    bless $self, $class
    return $self;
}

sub firstName {
    my ( $self, $firstName ) = @_;
    $self->{_firstName} = $firstName if defined($firstName);
    return $self->{_firstName};
}

#accessor method for Person last name
sub lastName {
    my ( $self, $lastName ) = @_;
    $self->{_lastName} = $lastName if defined($lastName);
    return $self->{_lastName};
}

#accessor method for Person address
sub address {
    my ( $self, $address ) = @_;
    $self->{_address} = $address if defined($address);
    return $self->{_address};
}

#accessor method for Person social security number
sub ssn {
    my ( $self, $ssn ) = @_;
    $self->{_ssn} = $ssn if defined($ssn);
    return $self->{_ssn};
}

sub print {
    my ($self) = @_;

    #print Person info
    printf( "Name:%s %s %s %s\n\n", $self->firstName, $self->lastName ,$self->address,$self->{_ssn} );
}

1;

