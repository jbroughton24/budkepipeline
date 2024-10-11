#!/bin/bash
#SBATCH --time=00:30:00
#SBATCH --mem-per-cpu=1000M
#SBATCH --nodes=1
#SBATCH --ntasks=1

#[[ -d $SLURM_SUBMIT_DIR ]] && cd $SLURM_SUBMIT_DIR
#module load ncbi_blast/2.6.0
for i in ..*.fa
{
    makeblastdb -in $i -out $i -dbtype nucl
}