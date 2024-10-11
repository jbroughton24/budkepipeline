#!/usr/bin/perl -w

@fastaFiles = glob("*.ortho.clean.fasta");
foreach $file (@fastaFiles)
{
    if ($file =~ m/(\S+)\.ortho\.clean\.fasta/)
    {
	$locus = $1;
	$fullSeqFile = "$locus.fa";
	open OUT1,'>', "$locus.ortho.clean.full.fasta";
	%probeSeqs = ();
	%fullSeqs = ();
	open FH1, '<', "$file";
	while (<FH1>)
	{
	    if (/^>(\S+)/)
	    {
		$tax = $1;
	    }
	    elsif (/(\S+)/)
	    {
		$seq = $2;
		$probeSeqs{$tax} = $seq;
	    }
	}
	close FH1;
	
	open FH1, '<', "$fullSeqFile";
	while (<FH1>)
	{
	    if (/^>(\S+)/)
	    {
		$tax = $1;
	    }
	    elsif (/(\S+)/)
	    {
		$seq = $1;
		$fullSeqs{$tax} = $seq;
		if (exists $probeSeqs{$tax})
		{
		    print OUT1 ">$tax\n$fullSeqs{$tax}\n";
		}
	    }
	}
	close FH1;
    }
}
close OUT1;
exit;
