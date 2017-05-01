#!/usr/bin/perl

use feature qw/say/;

my ($input_file1, $input_file2) = @ARGV;

my $output_file2 = $input_file2;
$output_file2 =~ s/^/goup./;

my @arr = split("/", $input_file1);
pop @arr;
my $input_dir = join("/", @arr);
$input_dir = "/" . $input_dir;
$input_file2 = $input_dir . "/" . $input_file2;
pop @arr;
push @arr, "output";
my $out_dir = join("/", @arr);
$out_dir = "/" . $out_dir;

