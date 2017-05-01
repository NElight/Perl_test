#!/usr/bin/perl

package Employee;
use strict;
use Person;
our @ISA = qw(Person);

sub new {
	my $class = shift @_;
	my $self = $class->SUPER::new($_[0], $_[1], $_[2]);
	$self ->{_id} = undef;
	bless $self, $class;
	return $self;
}

1;