#!/usr/bin/perl -w

@filearray = glob("*.fa");
for $file(@filearray)
{
    if ($file =~ m/(\S+).fa/)
    {
	$gene = $1;
	open FH, "<$file";
	open OUT, ">$gene.fasta";
	while (<FH>)
	{
	    if (/>(\S+)/)
	    {
		print OUT "\n>$1\n";
	    }

	    elsif (/(\S+)/)
	    {
		print OUT "$1";
	    }
	}
	print OUT "\n";
	close OUT;
	close FH;
    }
}


%locushash = ();

open FH2, "<allSeqs_rightdir.fasta";

while (<FH2>)
{
    if (/^>(L\d+)\_/)
    {
        $loc = $1;
        if (! exists $locushash{$loc})
        {
            $locushash{$loc} = 1;
        }
    }
}
close FH2;

for $LOC(keys %locushash)
{
    open FH3, "<allSeqs_rightdir.fasta";
    open OUT2, ">$LOC.fa";
    $ok = 1;
    while (<FH3>)
    {
        if (/^>$LOC\_\S+/)
        {
            print OUT2;
            $ok = 0;
        }
        elsif (/^>\S+/)
        {
            $ok++;
        }
        elsif ((/^\S+/) && ($ok == 0))
        {
            print OUT2;
        }
    }
    close FH3;
    close OUT2;
}
	
			
