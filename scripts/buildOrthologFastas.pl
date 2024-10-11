#!/usr/bin/perl -w

@ref = ("Anthoceros","Azolla","Ceratodon","Marchantia","Physcomitrella","Salvinia","Selaginella","Sphagnum");
@fastaFiles = glob("L*.fasta");
foreach $file (@fastaFiles)
{
    %seqs = ();
    %ortho = ();
    if ($file =~ m/(L\S+)\.fasta/)
    {
	$locus = $1;
	open FH1, '<', "$file";
	open OUT1 ,'>', "$locus.ortho.fasta";
	while(<FH1>)
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
	foreach $r (@ref)
	{
	    open FH1, '<', "$locus.orthologous.$r.coordinates";
	    while (<FH1>)
	    {
		if (/(\S+)\s+0/)
		{
		    $tax = $1;
		    if (! exists $ortho{$tax})
		    {
			print OUT1 ">$tax\n$seqs{$tax}\n";
			$ortho{$tax} = 1;
		    }
		    elsif (exists $ortho{$tax})
		    {
			#do nothing
		    }
		}
	    }
	}
    }
}
