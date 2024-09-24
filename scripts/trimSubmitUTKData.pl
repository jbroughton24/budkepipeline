#!/usr/bin/perl -w

# Assuming $ARGV[0] is the path to sampleID.txt, passed from Nextflow
open FH1, "<$ARGV[0]" or die "Cannot open sampleID.txt: $!";

while (<FH1>)
{
    if (/(RAPiD-Genomics_\S+)\s+\S+\s+\S+\s+\S+/)
    {
        $runid = $1;
        @files = glob("../rawReads/*$runid*");  # Adjusted path for rawReads directory
        open OUT1, ">$runid.trim.sh" or die "Cannot open output script file: $!";
        print OUT1 "#!/bin/bash\n";
        print OUT1 "trim_galore --quality 20 --length 30 --paired --fastqc $files[0] $files[1]\n";
        close OUT1;
        system "bash $runid.trim.sh";  # Use bash instead of sh for more compatibility
    }
}
