#!/usr/bin/perl

use feature qw/say/;

my @file = `ls -l`;
foreach (@file) {
	say $_;
}

if (!defined($pid = fork())) {
	die "�޷������ӽ���";
}elsif($pid == 0) {
	
}