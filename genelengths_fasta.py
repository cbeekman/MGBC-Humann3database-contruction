#Python script to calculate and attach gene length to each cluster member sequence
#__________________________________________________________________________________________________________________________________________________________________________________________


import time
import numpy as np
import Bio
from Bio import SeqIO

unirefFILE ="clustermembers_uniref.txt"                   # output from previous script containing clusterRep geneID, sequence geneID, and assigned uniref90 gene family
fastaFILE ="MGBC_Genes.fna"                               # original fasta file with genes from MGBC (compiled from prodigal gene-calling results)
headersFILE ="mmseqs_nucDB/MGBC_Genes_mmseqs_header.tsv"  # file containg fasta headers only (using only to get a count of the number of sequences being processed)
uniref2fastaFILE = "fasta_uniref.txt"                     # File for final output containing sequence geneID, uniref annotation, sequence length(bp), and sequence
unannotatedFILE = "fasta_unannotated.txt"

unirefARRAY = np.loadtxt(unirefFILE, dtype=str, comments=None)
headerARRAY = np.loadtxt(headersFILE, dtype=str, comments=None)
outARRAY = ["GeneID", "Gene_Family", "Gene_Length", "DNA_Sequence"]

outFILE = open(uniref2fastaFILE, "w")
outFILE_unannotated = open(unannotatedFILE, "w")

print ("uniref file loaded successfully")


sortedUNIREF = np.argsort(unirefARRAY[:,1])              # Sort unirefFILE by individual sequence (cluster member) geneIDs, returns a numpy array of original indexes in the sorted order

start = time.time()
with open(fastaFILE, 'r') as F:
    FASTA = list(SeqIO.parse(F, "fasta"))                # imports fastaFILE using built in biopython function, automatically collects header fields including gene ID and sequence per entry/sequence
    for entry in FASTA:
        matchSORTED = np.searchsorted(unirefARRAY[:,1], entry.id, sorter = sortedUNIREF)   # searches the SORTED member geneIDs from unirefARRAY for the current fasta entry's geneID, returns index
                                                                                           # ..where the fasta entry geneID would fit into the SORTED version of unirefARRAY (3rd postion match returns value of [2])
        
        matchUNSORTED = np.take(sortedUNIREF, matchSORTED)                                 # uses the SORTED index value (above) matched to the fasta entry to retrieve the corresponding index
                                                                                           #..within the original unsorted unirefARRAY using sortedUNIREF
        entrySTR = str(entry)
        splitENTRY= entrySTR.split(" # ")
        geneLENGTH = (int(splitENTRY[2]) - int(splitENTRY[1]))         # convert entry to string and split by delimiter in fasta header, subtract gene start position from gene end position to get gene length
        
        SEQUENCE = str(entry.seq)
        outARRAY = [entry.id, unirefARRAY[matchUNSORTED,3], geneLENGTH, SEQUENCE]  #store relevant fields to temporary list (replace previous values)
        
        if outARRAY[0] == unirefARRAY[matchUNSORTED,1]:   # check that fasta entry actually has an exact match in the unirefARRAY (ie that containing cluster was actually annotated in uniref search)

            outFILE.write(str(outARRAY) + "\n")                                        #write each new outARRAY as next line in output file

        else:

            outFILE_unannotated.write(str(outARRAY) + "\n")
         
end = time.time()
print ("time for ", (len(headerARRAY[:,0])), "sequences was: ", (end-start))

outFILE.close()
outFILE_unannotated.close()
