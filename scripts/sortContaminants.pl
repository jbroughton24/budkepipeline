#!/usr/bin/perl -w

%lineages = ();
open FH1, '<', "sampleID.txt";
while (<FH1>)
{
    if (/(\S+)\s+(\S+)\s+\S+\s+\S+/)
    {
	$id = $1;
	$lin = $2;
	$lineages{$id} = $lin;
    }
}
close FH1;

@fastaFiles = glob("*.ortho.fasta");
foreach $file (@fastaFiles)
{
    if ($file =~ m/(L\S+)\.ortho\.fasta/)
    {
	$locus = $1;
	%seqs = ();
	open OUT1, '>', "$locus.ortho.clean.fasta";
	open OUT2, '>', "$locus.ortho.contaminant.fasta";
	open FH1, '<', "$file";
	while (<FH1>)
	{
	    if (/^>(\S+)/)
	    {
		$tax = $1;
	    }
	    elsif (/(\S+)/)
	    {
		$seq = $1;
		$seqs{$tax} = $seq;
	    }
	}
	close FH1;
	$blastFile = "$locus.check.txt";
	open FH1, '<', "$blastFile";
#L237_UFG_393201_P03_WF08.Vandenboschia_radicans__comp0_seq0     L237_LeptosporangiateMonilophytes_Hymenophyllales_Hymenophyllum_bivalve_1__REF  97.500  40      1       0       1       120     1       120     4.16e-25        98.4
	while (<FH1>)
	{
	    if (/(\S+)\s+(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+/)
	    {
		$query = $1;
		$hit = $2;
		$check = 0;

		if ($query =~ m/L\d+\_(RAPiD-Genomics_\S+)\.\S+/)
		{
		    $temp = $1;
#		    $thisID = $1;
		    print "$temp\n";
		    $thisID = $lineages{$temp};
		}
		
		if ($thisID eq "Fern")
		{
		    if ($hit =~ m/\S+Monilophytes\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    if ($hit =~ m/\S+Salvinia\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    if ($hit =~ m/\S+Azolla\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		}

		if ($thisID eq "Gymnosperm")
		{
		    if ($hit =~ m/\S+Pinales\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    if ($hit =~ m/\S+Cycadales\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    if ($hit =~ m/\S+Gnetales\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    if ($hit =~ m/\S+Ginkgoales\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		}
		
		if ($thisID eq "Hornwort")
		{
		    if ($hit =~ m/\S+Hornworts\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		}

		if ($thisID eq "Liverwort")
		{
		    if ($hit =~ m/\S+Liverworts\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    elsif ($hit =~ m/\S+Marchantia\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		}

		if ($thisID eq "Lycophyte")
		{
		    if ($hit =~ m/\S+Lycophytes\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    if ($hit =~ m/\S+Selaginella\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		}

		if ($thisID eq "Moss")
		{
		    if ($hit =~ m/\S+Mosses\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    elsif ($hit =~ m/\S+Physcomitrella\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    elsif ($hit =~ m/\S+Ceratodon\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		    elsif ($hit =~ m/\S+Sphagnum\S+/)
		    {
			print OUT1 ">$query\n$seqs{$query}\n";
			$check = 1;
		    }
		}

		if ($check == 0)
		{
		    print OUT2 ">$query\n$seqs{$query}\n";
		}
	    }
	}
	close FH1;
	close OUT1;
    }
}
exit;
