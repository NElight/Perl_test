#!/usr/bin/perl

package Person;
sub new {
	my $class = shift;
	my $self = {
		_firstname => shift,
		_lastname => shift,
		_ssn => shift,
	};
	bless $self, $class;
	return $self;
	
}

sub getFirstName {
	my ($self) = @_;
	return $self -> {_firstname};

}


1;