#!/usr/bin/perl

#3、输入数据路径：/TJPROJ1/MICRO/lilifeng/Test/bctest/input/
#group.list    P.relative.xls
#结果文件路径：/TJPROJ1/MICRO/lilifeng/Test/bctest/output/
#P.relative.tran.xls    goup.P.relative.xls
#
#第1题：写一个脚本实现对表格P.relative.xls进行转置，得到结果文件：P.relative.tran.xls
#第2题：写一个脚本根据分组信息group.list 对 P.relative.xls 中的数据按照组来算平均值和标准差（输出值“avg：sd”），得到结果文件：goup.P.relative.xls

use Spreadsheet::ParseXLSX;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use Statistics::Descriptive;

use strict;
use feature qw/say/;

my ( $input_file1, $input_file2 ) = @ARGV;
my $output_file1;
my $output_file2;
$output_file1 = $input_file2;
$output_file2 = $input_file2;

my @dir_arr = split( "/", $input_file1 );
pop @dir_arr;
my $input_dir = join( "/", @dir_arr ) . "/";
$input_file2 = $input_dir . $input_file2;

pop @dir_arr;
push @dir_arr, "output";
my $output_dir = join( "/", @dir_arr ) . "/";

$output_file1 =~ s/xls$/tran.xls/;
$output_file1 = $output_dir . $output_file1;
$output_file2 =~ s/^/grop./;
$output_file2 = $output_dir . $output_file2;

#test---------------------------------------------------
#$input_file2  = "./P.relative.xls";
#$output_file1 = "./P.relative.trans.xls";

#test---------------------------------------------------

#my $parser     = Spreadsheet::ParseXLSX->new();
my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($input_file2);

if ( !defined $workbook ) {
	die $parser->error();
}
else {
	say "the file can use";
}

open GROUPLIST, "<", "group.list";
my %group_hash;
while (<GROUPLIST>) {
	my $temp_key;
	my $temp_value;
	if (/(\S+)\s+(\S+)/) {
		$temp_key = $1;
		$group_hash{$temp_key} = $2;
	}
}



for my $worksheet ( $workbook->worksheets() ) {
#test------------------------------------------------------------
#$output_file2 = "./grop.P.relative.xls";
#test------------------------------------------------------------
	my $output_group_data_excel = Spreadsheet::WriteExcel->new($output_file2);
	my $worksheet_group         = $output_group_data_excel->add_worksheet();
	my %reverse_group_hash = reverse %group_hash;
	my $write_row = 0;
	my $write_col_temp = 1;
	for (sort keys %reverse_group_hash) {
		$worksheet_group->write($write_row, $write_col_temp++, $_);
	}

	my ( $row_min, $row_max ) = $worksheet->row_range();
	my ( $col_min, $col_max ) = $worksheet->col_range();

	my @content_array;

	for my $row ( $row_min .. $row_max ) {

		my @col_content_array;
		my %statics_hash;
		for my $col ( $col_min .. $col_max ) {

			my $cell = $worksheet->get_cell( $row, $col );
			next unless $cell;

			my $value = $cell->value();
			push @col_content_array, $value;

			print "Row, Col    = ($row, $col)\n";
			print "Value       = ", $cell->value(),       "\n";
			print "Unformatted = ", $cell->unformatted(), "\n";
			print "\n";

			if ( $row > 0 ) {
				my @temp_arr = @{ $content_array[0] };
				if ( $col > 0 ) {
					my $t_key   = $temp_arr[$col];
					my $t_value = $group_hash{$t_key};
					if ( defined( $statics_hash{$t_value} ) ) {
						push @{ $statics_hash{$t_value} }, $value;
					}
					else {
						$statics_hash{$t_value} = [$value];
					}
				}
			}

			if ( $col == 0 ) {
				$worksheet_group->write( $row, $col, $value );
			}

		}

		if ( $row > 0 ) {
			my $write_col = 1;
			for my $group_row_data ( sort keys %statics_hash ) {

				my $stat = Statistics::Descriptive::Full->new();
				$stat->add_data( $statics_hash{$group_row_data} );
				my $average            = $stat->mean();
				my $standard_deviation = $stat->standard_deviation();
				$worksheet_group->write($row, $write_col++, join(":", $average, $standard_deviation));
			}
		}
		my $col_content_array_ref = \@col_content_array;

		push @content_array, $col_content_array_ref;
	}

	my $workbook = Spreadsheet::WriteExcel->new($output_file1);

	$worksheet = $workbook->add_worksheet();

	for my $col ( $row_min .. $row_max ) {
		for my $row ( $col_min .. $col_max ) {
			$worksheet->write( $row, $col, $content_array[$col]->[$row] );
			my $temp = $content_array[$row]->[$col];
			say "$row, $col, $temp";
		}
	}

}
