#!/usr/bin/perl

use strict;
use feature qw/say/;

my ($input_file, $sign_code) = @ARGV;

open INPUT, "<", $input_file;

print sprintf "%-15s%-15s%-15s%-15s%-15s\n", "Seq_id", "Seq_length", 'CG%', "Sign_num", "Sign_pos";

$/ = ">";
<INPUT>;
while(<INPUT>) {
	chomp;
	my $gene_id;
	my $gene_type;
	if(/(\S+).*?(\+|-)+/) {
		$gene_id = $1;
		$gene_type = $2;
	}
	s/.*?\n//;
	s/\s//g;
	
	my $gene_length = length ($_);
	my $GC_persent = do{
		my $GC_count = tr/GC/GC/;
		$GC_count / $gene_length * 100;
	};
	
	if ($gene_type eq "-"){
		$_ = reverse $_;
	}
	
	my ($pos, $now, $count) = (0, -1, 0);
	my @pos_arr;
	my $pos_str;
	until($pos == -1) {
		$pos = index($_, $sign_code, $now + 4);
		if ($pos > -1) {
			$count ++;
			$now = $pos;
			push @pos_arr, join("-", $pos, $pos + 3);
		}
	}
	
	$pos_str = join(",", @pos_arr);

	print sprintf "%-15s%-15d%-15.2f%-15d%-15s\n", $gene_id, $gene_length, $GC_persent, $count, $pos_str;
}

$/ = "\n";
close INPUT;
