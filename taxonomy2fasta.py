#Python script to match each genome to its assigned taxonomy (using taxonomy provided by MGBC publication) and attach taxonomy to FASTA sequence header along with unirefID and gene length
#__________________________________________________________________________________________________________________________________________________________________________________________


import time
import numpy as np
import Bio
from Bio import SeqIO


seqFILE ="fasta_uniref.txt"                      #input file with geneID, uniref90, gene length and nuc sequence per entry from previous script
taxFILE ="MGBC_genome-taxonomy_26640.txt"        #file mapping genomeIDs to taxonomy (from MGBC publication)
tax2fastaFILE = "MGBC_Genes_annotated.fna"       # output file name for fasta output with GeneID included 
bowtie2FILE = "MGBC_Genes_humann3.fna"           # output file name for fasta output formatted for humann3 bowtie2 index

taxARRAY = np.loadtxt(taxFILE, dtype=str, comments=None)  # load taxonomy mapping file as numpy array
sortedTAX = taxARRAY[taxARRAY[:,0].argsort()]
sortedTAX = np.char.strip(sortedTAX, '[],\'')             # sort taxonomy array by the column containing the GenomeID and remove extraneous characters 

print ("input files loaded successfully")

outFILE1 = open(tax2fastaFILE, "w")
outFILE2 = open(bowtie2FILE, "w")


start = time.clock()
with open (seqFILE, 'r') as file:                      # open seqFILE and loop through lines
    for line in file:
        line = line.split()                # split line into list of strings with " " as delimiter
        
        GENEID = line[0].strip("][',")     #
        UNIREF = line[1].strip("][',")     #
        LENGTH = int(line[2].strip(","))   # strip extraneous charaters and assign desired columns/fields of each line to variables
        SEQ = line[3].strip("][',")        #
        
        GENOME = GENEID.split(".")[0]      # extract genomeID from geneID field
        
        matchTAX = np.searchsorted(sortedTAX[:,0], GENOME)        # search GENOME ID for seqFILE entry/line against sorted TAX array, (returns index where it would be inserted in the sorted TAX to preserve
                                                                  # order of TAX 

        TAX = sortedTAX[matchTAX,1]        # retrieve the taxonomy (2nd column in TAX array) for seqFILE entry/line using the index returned from the sorted search above

        outFILE1.write(">%s|%s|%i|%s\n%s\n" % (GENEID, UNIREF, LENGTH, TAX, SEQ))    # write new line with relevant fields to fasta-formatted file including GeneID
        outFILE2.write(">%s|%i|%s\n%s\n" % (UNIREF, LENGTH, TAX, SEQ))               # write new line with relevant fields to fasta-formatted file without GeneID (formatted for humann3 index creation)
        
outFILE1.close()
outFILE2.close()

end = time.clock()
print ("loop time =", end-start)

