#!/usr/bin/perl

use strict;
use feature qw/say/;

my ($input_file, $output_file) = @ARGV;
my $code_file = "/home/liuwenbin/data/Code_table";

open INPUT, "<", $input_file;
open OUTPUT, ">>", $output_file;

my %pro_code_hash = &code_table_hash($code_file);

$/ = ">";
<INPUT>;
while(<INPUT>) {
	my $gene_id;
	my $gene_type;
	chomp;
	if (/((\S+.*?)(\+ | -)*.*)/) {
		$gene_id = $1;
		$gene_type = $3;
	}
	s/(.*?)\n//;
	s/\s//g;
	$_ = substr($_, 61, 240);
	if ($gene_type eq "-") {
		$_ = reverse $_;
	}
	
	my $pro_seq;
	for(my $i = 0; $i < length ($_); $i += 3){
		my $temp = substr($_, $i, 3);
		$pro_seq .= $pro_code_hash{$temp};
	}
	
	print OUTPUT ">" . $gene_id . $pro_seq;
	
	
}

$/ = "\n";
close INPUT;
close OUTPUT;

sub code_table_hash {
	my ($code_file) = @_;
	open TEMP, "<", $code_file;
	my %code_hash;
	my $code_line;
	my @code_array;
	while (<TEMP>) {
		if(/^11.*/) {
			$code_line = 0;
			next;
		}
		
		if (defined($code_line)) {
			push @code_array, $_;
			$code_line++;
		}
		
		if ($code_line == 5) {
			last;
		}
	}
	close TEMP;
	my $code_count = length($code_array[0]);
	for (my $i = 0; $i < $code_count; $i ++) {
		my $pro_key = substr($code_array[2], $i, 1) . substr($code_array[3], $i, 1) . substr($code_array[4], $i, 1);
		my $pro_value = substr($code_array[0], $i, 1);
		$code_hash{$pro_key} = $pro_value;
	}
	
	return %code_hash;
}
