#!/usr/bin/perl -w

#Mostly a bunch of steps to reformat data.  Before running this do the following:
# cp ../A03_probeTrimming/allSeqs_probeR.fasta .
# mv allSeqs_probeR.fasta allSeqs_probeR.fa
#After running, run the genome shell scripts in this directory

open FH, "allSeqs_probeR.fa";
open OUT, ">allSeqs_probeR.fasta";
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

system "rm allSeqs_probeR.fa";

%locushash = ();

open FH2, "<allSeqs_probeR.fasta";

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
    open FH3, "<allSeqs_probeR.fasta";
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


@filearray = glob("L*.fa");
for $file(@filearray)
{
    if ($file =~ m/(\S+).fa/)
    {
	$gene = $1;
	open FH4, "<$file";
	open OUT3, ">$gene.fasta";
	while (<FH4>)
	{
	    if (/>(\S+)/)
            {
		print OUT3 "\n>$1\n";
            }
                        
	    elsif (/(\S+)/)
            {
                print OUT3 "$1";
            }
	}
	print OUT3 "\n";
	close OUT3;
	close FH4;
    }
}

