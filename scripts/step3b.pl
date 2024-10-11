#!/usr/bin/perl -w                                                                                                           

#After 'MoreMem.sh' has finished running do the following before running this script
# cat *_probeR.fasta >allSeqs_probeR.fasta
# cat *_probe_hits.txt >allSeqs_probe_hits.txt

open FH, "<allSeqs_probe_hits.txt";
%revhash = ();

while (<FH>)
{
    if (/^(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)/)
    {
	$query = $1;
	$start = $2;
	$end = $3;
#	print "$query\t$start\t$end\n";
	if ($start > $end)
	{
	    $revhash{$query} = 1;
	}
    }
}

open FH2, "<allSeqs.fasta";
open OUT, ">allSeqs_rightdir.fa";
$num1 = 0;
$num2 = 0;

while (<FH2>)
{
    if (/^>(\S+)/)
    {
	$name = $1;
	print OUT;
	if (exists $revhash{$name})
	{
	    $rc = 0; 
	    $num1++;
	}
	else {$rc = 1; $num2++;}
    }
    elsif (/^(\S+)/)
    {
	$seq = $1;
	if ($rc == 1)
	{
	    print OUT;
	}
	else 
	{
	    $revseq = reverse $seq;
	    $revseq =~ tr/ACGT/TGCA/;
	    print OUT "$revseq\n";
	}
    }
}

