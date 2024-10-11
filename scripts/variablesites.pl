#!/usr/bin/perl -w

#This script reads in the phylip files defined below- currently written to include all files that end in .phy- and outputs the number of total sites, the number of variable sites (sites that have at least two different nucleotides), and the number of parsimony informative sites
@filearray = glob("*.phy");

for $file(@filearray)
{
    open FH, "<$file";
    $ok = 0;
    %Ahash = ();
    %Chash = ();
    %Ghash = ();
    %Thash = ();

#Read through the nexus file
#count number of a,c,g, or t characters in each column
    while (<FH>)
    {
        if (/^\d+\s+(\d+)/)
        {
	    $nchar = $1;
	    $ok++;
	}

	elsif (/^\S+\s+(\S+)/ && $ok > 0)
	{
	    $seq = $1;
#turning each sequence into an array of characters
	    @seqarray = split('',$seq);
	    $char = 0;
	    for $nuc(@seqarray)
	    {
	        $char++;
#I have a hash- the keys are the column numbers.  The values are the number of times an a,c,g, or t is in the column.
#		print "$nuc\n";
		if ($nuc eq A)
		{
		    $Ahash{$char}++;
		}
		if ($nuc eq C)
		{
		    $Chash{$char}++;
		}
		if ($nuc eq G)
		{
		    $Ghash{$char}++;
		}
		if ($nuc eq T)
		{
		    $Thash{$char}++;
		}
	    }
	}
    }
    close FH;

#now I will count how many alignment columns characters are parsimony informative
    $keepchars = 0;
    $varchars = 0;

    for (1..$nchar)
    {
        $count = $_;
        $okchars = 0;
	$okchars2 = 0;
	if ((exists $Ahash{$count}) && ($Ahash{$count} > 1))
        {
	    $okchars++;
	}
	if ((exists $Chash{$count}) && ($Chash{$count} > 1))
        {
	    $okchars++;
	}
	if ((exists $Ghash{$count}) && ($Ghash{$count} > 1))
	{
	    $okchars++;
	}
	if ((exists $Thash{$count}) && ($Thash{$count} > 1))
	{
	    $okchars++;
	}

	if ($okchars >= 2)
	{
	    $keepchars++;
	}

        if ((exists $Ahash{$count}) && ($Ahash{$count} > 0))
        {
            $okchars2++;
        }
        if ((exists $Chash{$count}) && ($Chash{$count} > 0))
        {
            $okchars2++;
        }
        if ((exists $Ghash{$count}) && ($Ghash{$count} > 0))
        {
            $okchars2++;
        }
        if ((exists $Thash{$count}) && ($Thash{$count} > 0))
        {
            $okchars2++;
        }

        if ($okchars2 >= 2)
        {
            $varchars++;
        }
	


    }


    print "$file\t$nchar\t$varchars\t$keepchars\n";
}

	    
