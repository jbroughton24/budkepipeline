#!/usr/bin/perl -w

$shFiles = glob("*.sh");
foreach $file (@shFiles)
{
	if ($file =~ m/(\S+)\.mafft\.sh/)
	{
	$locus = $1;
	system "sh $locus.mafft.sh"
	}
}




#for $file in *.sh; do bash $file; done;


#mafft --thread 4 --adjustdirectionaccurately --allowshift --unalignlevel 0.8 --leavegappyregion --maxiterate 5 --globalpair L1.ortho.clean.full.fasta > L1.beforeMerge.mafft.fasta