#!/bin/bash

#SBATCH -n 18
#SBATCH --mem=120G
#SBATCH -t 24:00:00
#SBATCH -J mmseqs_convert2fasta_nuc


#generate TSV file with Top Hit annotation information
mmseqs convertalis --format-output "query,target,evalue" \
                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/nucleotide/intermediate_files/mmseqs_nuc_repseqs/MGBC_Genes_clusters_rep.db \
                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/uniref/uniref90 \
                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/nucleotide/intermediate_files/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90_TopHit \
                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/nucleotide/intermediate_files/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90_TopHit_evals.tsv \

