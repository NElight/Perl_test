#!/usr/bin/perl

use feature qw/say/;

my @file = `ls -l`;
foreach (@file) {
	say $_;
}

if (!defined($pid = fork())) {
	die "无法创建子进程";
}elsif($pid == 0) {
	
}