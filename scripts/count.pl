#!/usr/bin/perl -w

@filearray = glob("L*.nodups.phy");

%taxhash = ();

for $file(@filearray)
{
    open FH, "<$file";
    while (<FH>)
    {
	if ((/^(\S+)\s+\S+/) && (! /^\d+/))
	{
	    $tax = $1;
	    if (! exists $taxhash{$tax})
	    {
		$taxhash{$tax} = 1;
	    }
	    else {$taxhash{$tax}++;}
	}
    }
    close FH;
}

for $TAX(keys %taxhash)
{
    print "$TAX\t$taxhash{$TAX}\n";
}
