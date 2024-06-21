#!/bin/bash

#SBATCH -n 120
#SBATCH --mem=120G
#SBATCH -t 96:00:00
#SBATCH -J vsearch_MGBC


#module load vsearch


for samples in /users/cbeekman/scratch/GImapping/databases/humann3/custom/prodigal_nuc/*    # adjust to directory where input genome files are located
do
	file=${samples##*prodigal_nuc/}    #
	genome=${file%%.*}                 # These lines get genomeID from full directory string 
	#echo $file                        #
	#echo $genome                      #

	vsearch --derep_fulllength ${samples} \
		--output /users/cbeekman/scratch/GImapping/databases/humann3/custom/vsearch_dereplicated/${genome}_derep.fna \
		--notrunclabels   
done
