#!/bin/bash

#SBATCH -n 96
#SBATCH --mem=375G
#SBATCH -t 48:00:00
#SBATCH -J FORMAT-FASTA-Nuc


cd /users/cbeekman/scratch/GImapping/databases/humann3/custom

#_______________________________________________________________________________________________________________________________________________________________________________________
#Calling Python script to apply uniref90 annotations from each representative sequence GeneID to GeneIDs of each cluster member

module load numpy

#python uniref2clustermembers.py

#________________________________________________________________________________________________________________________________________________________________________________________
#Merging gene length and gene sequence for each cluster member GeneID with uniref annotation

module load biopython

#python genelengths_fasta.py


#_______________________________________________________________________________________________________________________________________________________________________________________
#Adding taxonomy to fasta header information from previous scripts


#python taxonomy2fasta.py


#________________________________________________________________________________________________________________________________________________________________________________________
# Building Bowtie2 index using the final annotated fasta file formatted according to humann3 requirements

module load bowtie2

bowtie2-build --threads 12 -f MGBC_Genes_humann3.fna MGBC_uniref90

