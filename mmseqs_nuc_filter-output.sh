#!/bin/bash

#SBATCH -n 180
#SBATCH --mem=120G
#SBATCH -t 24:00:00
#SBATCH -J mmseqs_convert2fasta_nuc

#filter annotation results by e-value (<1e-5), This becomes irrelevant since I am picking only the best hit per cluster for subsequent steps, but left here incase it is useful in some other application
#mmseqs filterdb /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90 \
#                /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90_eval1e-5 \
#                --filter-column 4 --comparison-operator le --comparison-value 1e-5


#Create alignment result file in Blast tab format
#mmseqs convertalis /users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs_repseqs/MGBC_Genes_clusters_rep.db \
#      	            /users/cbeekman/scratch/GImapping/databases/humann3/custom/uniref90 \
#                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90 \
#                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90.m8 \


# create alignment database with only top alignment for each query (alignment DBs are sorted by E-value)
#mmseqs filterdb --extract-lines 1 \
#                /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90 \
# 		/users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90_TopHit

#generate TSV file with Top Hit annotation information
mmseqs convertalis --format-output "query,target" \
	           /users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs_repseqs/MGBC_Genes_clusters_rep.db \
                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/uniref90 \
                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90_TopHit \
                   /users/cbeekman/scratch/GImapping/databases/humann3/custom/annotated_uniref90/MGBC_Genes_clusters_rep_uniref90_TopHit.tsv \
