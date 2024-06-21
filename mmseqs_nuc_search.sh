#!/bin/bash

#SBATCH -n 180
#SBATCH --mem=375G
#SBATCH -t 96:00:00
#SBATCH -J mmseqs_search_MGBC_nuc



#mmseqs databases UniRef90 /users/cbeekman/scratch/GImapping/databases/humann3/custom/uniref90 temp_mmseqs_databases

mmseqs touchdb uniref90

mmseqs search  --forward-frames 1 --reverse-frames 0 --orf-start-mode 0 --translation-table 11 --sens-steps 3 --num-iterations 2 --db-load-mode 3\
               /users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs_repseqs/MGBC_Genes_clusters_rep.db \
	       /users/cbeekman/scratch/GImapping/databases/humann3/custom/uniref90 \
	       /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90 \
	       /users/cbeekman/scratch/GImapping/databases/humann3/custom/temp_uniref90_annotation

#Realized there is an issue with the nucleotide translation of query database, by default mmseqs will pull out all possible translations (any start to stop on any reading frame, turns ~5mil orfs to 
#~86mil proteins), this is not appropriate for this query db as all individual sequences represent complete ORFs predicted by prodigal
#--orf-start-mode parameter changes this behavior and --forward/reverse-frames restricts the number of reading frames it will use in the search as well so that only a single reading frame per CDS is searched
