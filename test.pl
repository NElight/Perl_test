#!/usr/bin/perl

use Person;
use Employee;

my $object = new Person( "xiaoming", "wang", 2334324 );
print $object->getFirstName;

my $employee = new Employee( "xiaoli", "li", 23432432423 );
print $employee ->getFirstName;

$lstr = "abcdefg";
$lstr =~ s/(\w+)/\U$1/;
print $lstr;

$lstr = lc($lstr);
print $lstr;
$lstr = uc($lstr);
print $lstr;

sub switch() {
	my $a = shift;
	$a = "cbad ";
	return $a;
}
@arr = qw/1 2 3 4 5 6/;
@arr2 = map switch (), @arr;
print "\n" . "@arr2";


my %a = (a=>1, b=>2);
my %b = (c=>3, d=>4);
my %c = (e=>\%a, f=>\%b);
my $d = \%c;

$a{"abc"} = {};

$a{"abc"} -> {"efg"} = 1234;

print $a{"abc"}->{"efg"};
print "\n";

my $str = "abc";
my $num = chomp($str);
print $num;

my $fh = FH;
open $fh, ">>", "./test";



my @a = qw(a b c\n);
print @a;

&sum2(1, 3);
sub sum2() {
	my ($a, $b) = @_;
	return $a + $b;
}
print "\n";
my $line = "abcdefg\n";
print chomp($line);
chop($line);
print $line;

print "\n";
my %hash = (a=>1, b=>2,c=>3, d=>4,e=>5);
print scalar (%hash);

my @arr = (2,14,3);
my @arr2 = sort @arr;
print @arr2 . "\n";

my $a =1;
print ++$a;

print <<"EOF";
asfd as ldfjaslj f
asf as jlajs flajsf
as fasf as fas f
EOF






