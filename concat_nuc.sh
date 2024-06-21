#!/bin/bash

#SBATCH -n 120
#SBATCH --mem=120G
#SBATCH -t 48:00:00
#SBATCH -J concat_MGBC_nuc


cat /users/cbeekman/scratch/GImapping/databases/humann3/custom/vsearch_dereplicated/*.fna > /users/cbeekman/scratch/GImapping/databases/humann3/custom/MGBC_Genes.fna   
