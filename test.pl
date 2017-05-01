#!/usr/bin/perl

use Person;
use Employee;

my $object = new Person("xiaoming", "wang", 2334324);
print $object->getFirstName;

my $employee = new Employee("xiaoli", "li", 23432432423);
print $employee ->getFirstName;