#!/usr/bin/perl -w

open OUT1, '>', "contaminationBlast.sh";
#print OUT1 "#!/bin/bash\n#SBATCH --time=24:00:00\n#SBATCH --mem-per-cpu=1000M\n#SBATCH --nodes=1\n#SBATCH --ntasks=1\n[[ -d \$SLURM_SUBMIT_DIR ]] && cd \$SLURM_SUBMIT_DIR\nmodule load ncbi_blast/2.6.0\n";

@fastaFiles = glob("*.ortho.fasta");
foreach $file (@fastaFiles)
{
    if ($file =~ m/(L\S+)\.ortho\.fasta/)
    {
	$locus = $1;
	$refdb = "$locus.fa";
	print OUT1 "tblastx -num_threads 1 -max_target_seqs 1 -max_hsps 1 -outfmt 6 -query $file -out $locus.check.txt -db $refdb\n";
    }
}
close OUT1;
exit;
