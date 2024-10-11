#!/usr/bin/perl -w

@ref = ("Anthoceros","Azolla","Ceratodon","Marchantia","Physcomitrella","Picia","Pinus","Salvinia","Selaginella","Sphagnum");
for $i (0..9)
{
$reference = $ref[$i];

@files = glob("*.$reference.txt");
foreach $file (@files)
{
    %coordinates = ();
    %seqList = ();
    if ($file =~ m/(\S+)\.fa\.$reference\.txt/)
    {
	$locus = $1;
	open OUT1, '>', "$locus.orthologous.$reference.coordinates";
	open OUT2, '>', "$locus.paralogs.$reference.coordinates";
    }
    open FH1, '<', "$file";
    while (<FH1>)
    {
	if (/(\S+)\s+(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+(\S+)/)
	{
	    $seq = $1;
	    $scaffold = $2;
	    $scaffoldStart = $3;
	    $scaffoldStop = $4;
	    $bit = $5;

	    if ($scaffoldStop < $scaffoldStart)
	    {
		$temp = $scaffoldStart;
		$scaffoldStart = $scaffoldStop;
		$scaffoldStop = $temp;
	    }

	    if (! exists $coordinates{$seq}{bit})
	    {
		$coordinates{$seq}{scaffold} = $scaffold;
		$coordinates{$seq}{start} = $scaffoldStart;
		$coordinates{$seq}{stop} = $scaffoldStop;
		$coordinates{$seq}{bit} = $bit;
		$coordinates{$seq}{ortho} = 1;
		$seqList{$seq} = 1;
	    }
	    elsif (exists $coordinates{$seq}{bit})
	    {
		if ($bit >= (0.95 * $coordinates{$seq}{bit}))
		{
		    if (($scaffold eq $coordinates{$seq}{scaffold}) && ($scaffoldStart > ($coordinates{$seq}{start} - 1000)) && ($scaffoldStop < ($coordinates{$seq}{stop} + 1000)))
		    {

		    }
		    else
		    {
			print OUT2 "$locus\t$seq\t$coordinates{$seq}{scaffold}\t$coordinates{$seq}{start}\t$coordinates{$seq}{stop}\t$coordinates{$seq}{bit}\t$scaffold\t$scaffoldStart\t$scaffoldStop\t$bit\n";
			$coordinates{$seq}{ortho} = 0;
		    }
		}
		elsif ($bit < (0.95 * $coordinates{$seq}{bit}))
		{
		    #do nothing
		}
	    }
	}
    }
    close FH1;
    %consensus = ();
    foreach $SEQ (keys %seqList)
    {
	if ($coordinates{$SEQ}{ortho} == 1)
	{
	    if (! exists $consensus{scaffold}[0])
	    {
		push @{$consensus{scaffold}}, $coordinates{$SEQ}{scaffold};
		push @{$consensus{start}}, $coordinates{$SEQ}{start};
		push @{$consensus{stop}}, $coordinates{$SEQ}{stop};
	    }
	    elsif (exists $consensus{scaffold}[0])
	    {
		$check = 0;
		for $i (0..(scalar(@{$consensus{scaffold}})-1))
		{
		    if ($consensus{scaffold}[$i] eq $coordinates{$SEQ}{scaffold})
		    {
			$check = 1;
			if (($coordinates{$SEQ}{start} > ($consensus{start}[$i] - 1000)) && ($coordinates{$SEQ}{stop} < ($consensus{stop}[$i] + 1000)))
			{
			    if ($coordinates{$SEQ}{start} < $consensus{start}[$i])
			    {
				$consensus{start}[$i] = $coordinates{$SEQ}{start};
			    }
			    if ($coordinates{$SEQ}{stop} > $consensus{stop}[$i])
			    {
				$consensus{stop}[$i] = $coordinates{$SEQ}{stop};
			    }
			}
		    }
		}
		if ($check == 0)
		{
		    push @{$consensus{scaffold}}, $coordinates{$SEQ}{scaffold};
		    push @{$consensus{start}}, $coordinates{$SEQ}{start};
		    push @{$consensus{stop}}, $coordinates{$SEQ}{stop};
		}
	    }
	}
    }
    foreach $SEQ (keys %seqList)
    {
        if ($coordinates{$SEQ}{ortho} == 1)
        {
	    for $i (0..(scalar(@{$consensus{scaffold}})-1))
	    {
		if (($coordinates{$SEQ}{scaffold} eq $consensus{scaffold}[$i]) && ($coordinates{$SEQ}{start} >= $consensus{start}[$i]) && ($coordinates{$SEQ}{stop} <= ($consensus{stop}[$i])))
		{
		    print OUT1 "$SEQ\t$i\n";
		}
	    }
	}
    }
}
close OUT1;
}
exit;
