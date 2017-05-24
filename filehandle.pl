#!/usr/bin/perl
#
#use strict;
use Cwd qw(abs_path getcwd);

our $datadir = ".";
our $outsh = "./network.sh";
open OUT, ">", $outsh;
&start();

sub start() {
    my @dirlist = `ls $datadir`;
    foreach (@dirlist) {
        my $abs_path = abs_path(getcwd());
        $abs_path .= "/";
        $abs_path .= $_;
        if (-d $abs_path) {
            my $netdir = $_ . "_network";
            if (-e $netdir){
                next;
            }else {
                system "mkdir $netdir";
            }
            print OUT <<EOF;
cd $netdir
perl -ne 'chomp; my \@ll=split/\t/;\$ll[0]=~s/\.//g;\$ll[-1]=~s/\.//g;print join("\t",\@ll),"\n";' /ifs/TJPROJ3/MICRO/yangzengguang/reanalysis/NHT160866-P2016090921/data/$_/Relative/otu_table.g.relative.xls > otu_table.g.relative.xls  #change by yang to delete dot in otutable 20170417
perl /PUBLIC/software/MICRO/share/16S_pipeline/16S_pipeline_V3.1/lib/05.Statistic/lib/NetWork/bin/../lib/handle.table.pl otu_table.g.relative.xls genus
perl /PUBLIC/software/MICRO/share/16S_pipeline/16S_pipeline_V3.1/lib/05.Statistic/lib/NetWork/bin/../lib/Beta_diversity_index.pl genus.table.xls genus.table.xls -index SCC -list genus.SCC.index.list --cutoff 0.6

EOF
        }
    }
}



