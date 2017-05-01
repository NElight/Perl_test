#!/usr/bin/perl

use feature qw/say/;

#my $text = "abcdefg hijklmn opqrst uvq xyz";
#format STDOUT = 
#first:^<<<<<
#	$text
#second:^<<<<<
#	$text
#third:^<<<<<<
#	$text
#.
#write;

format EMPLOY =
====================
@<<<<<<<<<<<<<<< @<<
$name $age
@#####.##
$salary
====================
.

format EMPLOY_TOP =
====================
Name             age@<
					$%
====================
.

@n = ("job", "john", "jojjy");
@a = (13, 344, 45);
@s = (200, 2000, 230000);

$~ = EMPLOY;
$^ = EMPLOY_TOP;

my $i = 0;
for (@n) {
	$name = $_;
	$age = $a[$i];
	$salary = $s[$i++];
	write;
	
}




