#!/bin/bash

#SBATCH -n 180
#SBATCH --mem=375G
#SBATCH -t 96:00:00
#SBATCH -J mmseqs-linclust_MGBC_nuc

#create mmseqs2 database from compiled fasta file
#mmseqs createdb MGBC_Genes.fna MGBC_Genes_mmseqs.db

#cluster all gene sequences at 95% identity (80% cov by default)
#mmseqs linclust --threads 1 --min-seq-id 0.95 \
#		/users/cbeekman/scratch/GImapping/databases/humann3/custom/MGBC_Genes_mmseqs.db \
#		/users/cbeekman/scratch/GImapping/databases/humann3/custom/MGBC_Genes_clusters.db \
#		tmp_mmseqs-linclust

#make sequence db of representative sequences from each cluster
#mmseqs createsubdb \
#	/users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs-linclust_output/MGBC_Genes_clusters.db.index \
#	/users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs_nucDB/MGBC_Genes_mmseqs.db \
#	/users/cbeekman/scratch/GImapping/databases/humann3/custom/MGBC_Genes_clusters_rep.db

#convert db of cluster representative sequences to fasta file
#mmseqs convert2fasta /users/cbeekman/scratch/GImapping/databases/humann3/custom/MGBC_Genes_clusters_rep.db /users/cbeekman/scratch/GImapping/databases/humann3/custom/MGBC_Genes_clusters_rep.fasta

#make tsv file of clusters (column1 = cluster representative GeneID, column2 = cluster member GeneID)
#mmseqs createtsv /users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs_nucDB/MGBC_Genes_mmseqs.db \
#		 /users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs_nucDB/MGBC_Genes_mmseqs.db \
#                 /users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs-linclust_output/MGBC_Genes_clusters.db \
#                 /users/cbeekman/scratch/GImapping/databases/humann3/custom/mmseqs-linclust_output/MGBC_Genes_clusters.tsv
