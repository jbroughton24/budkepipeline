#!/usr/bin/perl -w

#This script takes all the phylip files ending in *prune.phy (i.e., the output of filtermissing.pl), and concatenates them into a supermatrix
#You can change the glob function below to read in the names of different phylip files you want to concatenate
#change the names of the output files - the supermatrix file and the gene boundaries file - below

use strict;
use warnings;

my $file;
my @filearray = glob("*.prune.phy");
open OUT1, ">output.txt";
open OUT2, ">gene_boundaries.txt";

my %taxhash = ();
my $numtax = 0;
my $totallen = 0;

for $file (@filearray) {
    open FH, "<$file";
    while (<FH>) {
        if (/^\d+\s+(\d+)/) {
            $totallen += $1;
        } elsif (/^(\S+)\s+\S+/) {
            my $tax = $1;
            if (!exists $taxhash{$tax}) {
                $taxhash{$tax} = "";
                $numtax++;
            }
        }
    }
    close FH;
}

print OUT1 "DNA, p1=1-$totallen\n";

my $start = 1;
my $end = 0;
my $loci_num = 1;

for $file (@filearray) {
    open FH2, "<$file";
    my %genehash = ();
    while (<FH2>) {
        if (/^\d+\s+(\d+)/) {
            $end = $start + $1 - 1;
            my $loci = "DNA, p$loci_num=$start-$end";
            print OUT2 "$loci\n";
            $loci_num++;
        } elsif (/^(\S+)\s+(\S+)/) {
            $genehash{$1} = $2;
        }
    }
    close FH2;

    for my $TAX (keys %taxhash) {
        if (exists $genehash{$TAX}) {
            $taxhash{$TAX} .= $genehash{$TAX};
        } else {
            $taxhash{$TAX} .= "-" x ($end - $start + 1);
        }
    }
    $start = $end + 1;
}

for my $TAX (keys %taxhash) {
    print OUT1 "$TAX\t$taxhash{$TAX}\n";
}

close OUT1;
close OUT2;

