#!/bin/bash

#SBATCH -n 96
#SBATCH --mem=375G
#SBATCH -t 96:00:00
#SBATCH -J mmseqs_search_MGBC_prot


#download full uniref90 database:
#mmseqs databases UniRef90 /users/cbeekman/scratch/GImapping/databases/humann3/custom/uniref90 temp_mmseqs_databases

# load uniref db into memory
mmseqs touchdb uniref/uniref90  

mmseqs search  --sens-steps 3 --num-iterations 2 --db-load-mode 3\
               /users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs_prot_repseq/MGBC_Prot_clusters_rep.db \
	       /users/cbeekman/scratch/GImapping/databases/humann3/custom/uniref/uniref90 \
	       /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_prot_uniref90/MGBC_Prot_clusters_rep_uniref90 \
	       /users/cbeekman/scratch/GImapping/databases/humann3/custom/temp_uniref90_annotation
