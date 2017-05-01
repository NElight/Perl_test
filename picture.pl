#!/usr/bin/perl

use strict;
use feature qw/say/;

use SVG;

my ($input_file) = @ARGV;

open OUTPUT, ">", "rel.svg";

my $bin = 50;
my $step = 5;
open IN, "<", $input_file || die;  
$/=">";<IN>;$/="\n";  
print "#Chr\tStart\tEnd\tGC_num\tRatio\n";  

my %gene_GC_hash;
while(<IN>){  
    my $chr=$1 if /^(\S+)/;  
    $/=">";  
    chomp(my $seq=<IN>);  
    $/="\n";  
    $seq=~s/\n+//g;  
    my $len=length$seq;
    my @per_GC_percent;
    for (my $i=0;$i<$len - 50;$i += 5){  
        my $loc=$i;  
        my $sub_fa=uc(substr($seq,$loc,$bin));  
        my $GC=$sub_fa=~tr/GC//;
        my $ratio=sprintf "%.2f",$GC/$bin;  
        $ratio *= 100;
        my $start=$i+1;  
        my $end=$start + 49;
        my $out=join "\t",$chr,$start,$end,$GC,$ratio;  
        print $out,"\n";
        #print "$out\t$sub_fa\n" unless $GC;  
        push @per_GC_percent, $ratio;
    }
    
    $gene_GC_hash{$chr} = [@per_GC_percent];
    
}  


my $svg_x = 0;
my $svg_y = 0;
my $width = 535;
my $height = 230;
my $edge = 30;
my @pic_array = keys %gene_GC_hash;
my $pic_count = $#pic_array + 1;

my $svg = SVG->new(width=>$width, height=>($height * $pic_count));
for my $key (keys %gene_GC_hash) {
	my $max_count = 0;
	my %per_per_hash;
	for my $percent (@{$gene_GC_hash{$key}}){
		$per_per_hash{$percent} += 1;
		if($per_per_hash{$percent} > $max_count) {
			$max_count = $per_per_hash{$percent};
		}
	}
#test--------------------------------------------------------------
	for my $temp (keys %per_per_hash) {
		say "$key ------------ $temp : $per_per_hash{$temp}";
	}
#test--------------------------------------------------------------
	
	#»­Í¼
	my $temp_id_line = 'group_black_line' . $key;
	my $temp_id_rect = 'group_green_rect' . $key;
	my $black_line = $svg->group(id=>$temp_id_line, style=>{stroke=>'black', 'stroke-width',1});
	my $green_rect = $svg->group(id=>$temp_id_rect, style=>{stroke=>'geenn', fill=>'green'});
	
	$black_line->line(x1=>$edge,y1=>($svg_y + $height - $edge), x2=>$width, y2=>($svg_y + $height- $edge));
	$black_line->line(x1=>$edge, y1=>$svg_y + 0, x2=>$edge, y2=>($svg_y + $height - $edge));
	
	my $x_step = ($width - $edge) / 101;
	for (my $i = $edge + $x_step; $i <= $width; $i += $x_step){
		$black_line->line(x1=>$i, y1=>($svg_y + $height - $edge), x2=>$i, y2=>($svg_y + $height - $edge + 5));
	}
	
	my $y_step = ($height - $edge) / $max_count;
	for (my $i = $height - $edge; $i >= 0; $i -= $y_step) {
		$black_line->line(x1=>$edge,y1=>$svg_y + $i, x2=>$edge - 5, y2=>$svg_y + $i);
	}
	
	for my $temp (keys %per_per_hash) {
		my $r_x = $temp * $x_step + $edge;
		my $r_height = $per_per_hash{$temp} * $y_step;
		my $r_width = $x_step;
		my $r_y = $svg_y + $height - $edge - $r_height;
		$green_rect ->rectangle(
            x     => $r_x, y      => $r_y,
            width => $r_width, height => $r_height,
        );
	}
	
	$svg_y += $height;
	
}
my $out = $svg->xmlify();
say $out;
print OUTPUT $out;



