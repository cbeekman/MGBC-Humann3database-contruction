# MGBC-Humann3database-contruction
This repository contains code to generate custom databases for use in the Humann3 metagenomic pipeline based on the Mouse Gastrointestinal Bacterial Catalog collection of high-quality genomes

### This is a list of steps taken to construct the custom nucleotide database from the Mouse Gastrointestinal Bacteria Catalog (MGBC) high-quality genome collection for use in humann3 pipeline


#    INPUT FILES: MGBC high-qual genomes (26,640 assemblies), (https://github.com/BenBeresfordJones/MGBC) 
#
#    Step1. Gene prediction from assembly contig sequences with Prodigal package, generates fasta files with individual gene entries per genome
#           SCRIPT: prodigal.sh
#
#    Step2. Dereplicate each genome (gene predictions/prodigal outputs) to remove genes with identical sequence to others in genome (ie remove duplicate genes)
#           SCRIPT: vsearch_nuc.sh
#
#    Step3. Concatenate all genomes into a single FASTA file for mmseqs input (geneIDs in fasta headers will enable matching to original genome later)
#           SCRIPT: concat_nuc.sh
#    
#    Step4. Create a mmseqs sequence database with the concated FASTA file as input. Cluster all genes by sequence identity with mmseqs linclust, cluster output consists of representative 
#           geneID per cluster and geneIDs for all cluster members. Next a new sequence database is generated with only the representative genes from each cluster (single gene per cluster).
#           this will substantially reduce the number of genes that will need to be searched and annotated against the uniref database which take a lot of processing time.
#           SCRIPT: mmseqs_nuc_create-cluster.sh 
#       
#    Step5. Search sequence database of cluster representatives against the uniref(90) database to retrieve annotations for each gene cluster. used default evalue cutoff which is < 0.001
#           SCRIPT: mmseqs_nuc_search.sh       
#
#    Step6. Filter annotated mmseqs (alignment) database to retrieve only the top uniref gene family hit per cluster, results in 27717 annotations with eval > 0.00001 and 14314 with eval > 0.0001 
#           out of 5508955 query sequences.       
#           SCRIPT: mmseqs_nuc_filter-output.sh
#
#    Step7. Post processing mmseqs output to apply uniref annotations to all cluster members and generate annotated FASTA file in format needed for humann3 bowtie2 index. bash script calls multiple python
#           scripts in the required order to take different files as input and produce the final formatted FASTA file and then build the bowtie2 index.
#           SCRIPT: annotateFASTA.sh

###_____________________________________________________________________________________________________________________________________________________________


### This is a list of steps taken to construct the custom amino acid database from the Mouse Gastrointestinal Bacteria Catalog (MGBC) high-quality genome collection for use in humann3 pipeline

#    INPUT FILES: MGBC high-qual genomes (26,640 assemblies), ("MGBC-hqnr_26640_FNA/MGBC*.fna") 
#
#    Step1. Gene prediction from assembly contig sequences with Prodigal package, generates fasta files with individual gene entries per genome
#           SCRIPT: prodigal.sh
#
#    Step2. Concatenate all genomes into a single FASTA file for mmseqs input (geneIDs in fasta headers will enable matching to original genome later)
#           SCRIPT: concat_prot.sh
#    
#    Step2. Create a mmseqs sequence database with the concated FASTA file as input. Cluster all genes by sequence identity with mmseqs linclust, cluster output consists of representative 
#           geneID per cluster and geneIDs for all cluster members. Next a new sequence database is generated with only the representative genes from each cluster (single gene per cluster).
#           this will substantially reduce the number of genes that will need to be searched and annotated against the uniref database which take a lot of processing time.
#           SCRIPT: mmseqs_prot_create-cluster.sh 
#       
#    Step4. Search sequence database of cluster representatives against the uniref(90) database to retrieve annotations for each gene cluster. used default evalue cutoff which is < 0.001
#           SCRIPT: mmseqs_prot_search.sh       
#
#    Step5. Filter annotated mmseqs (alignment) database to retrieve only the top uniref gene family hit per cluster, results in 27717 annotations with eval > 0.00001 and 14314 with eval > 0.0001 
#           out of 5508955 query sequences.       
#           SCRIPT: mmseqs_prot_filter-output.sh
#
#    Step6. Post processing mmseqs output to apply uniref annotations to all cluster members and generate annotated FASTA file in format needed for humann3 bowtie2 index. bash script calls multiple python
#           scripts in the required order to take different files as input and produce the final annotated FASTA file and then generate diamond index database from annotated FASTA file
#           SCRIPT: annotate_prot_FASTA.sh
#
#

