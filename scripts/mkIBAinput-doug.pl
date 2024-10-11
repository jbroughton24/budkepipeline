#!/usr/bin/perl -w

###NOTE - Before running this script check the paths ###
#Also make sure you've moved sampleID.txt into this directory

open FH, "<sampleID.txt";

while (<FH>)
{
    if (/(RAPiD-Genomics_\S+)\s+\S+\s+(\S+)\s+(\S+)/)
    {
	$runid = $1;
	$tax = "$2\_$3";
	$tax =~ s/\.//g;
	$outputName = "$runid\.$tax";
#Change path in next line to match where this file lives in your environment
	@files = glob("/runData/*$runid*.fq");
	$file1 = $files[0];
	$file2 = $files[1];
	
	open OUT, ">$outputName.sh";
	print OUT "#!/bin/sh\n";
	print OUT "mkdir ./IBAass_$outputName\n";
	print OUT "cd ./IBAass_$outputName\n";
	print OUT "export OMP_NUM_THREADS=16\n";
#Change path in next line to match where this file lives in your environment
#Change the number after -p in the line below to specify the number of cores on the machine where you are running this. 
	print OUT "python /root/IBA-doug.py -raw1 $file1 -raw2 $file2 -d /refData/ref -n 3 -t 1 -p 6 -g 200 -c 10 -label REF -k 25 -taxa $outputName\n";
	close OUT;
	system "bash $outputName.sh";	
    }
}

	
	
