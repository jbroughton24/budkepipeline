#!/usr/bin/perl -w

#This file reads in the phylip file identified below and outputs the perecentage of sites with nucleotides
open FH, "<JRB.14Apr2023.phy";

$seqlen = 0;

while (<FH>)
{
    if (/^(\d+)\s+(\d+)/)
    {
	$total = $1 * $2;
    }
    elsif (/^\S+\s+(\S+)/)
    {
	$seq = $1;
	$seq =~ s/[^A-Z]//g;
	$len = length $seq;
	$seqlen = $seqlen + $len;
    }
}

$percent = $seqlen / $total;
print "$percent\n";
