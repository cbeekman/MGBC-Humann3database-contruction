#Python script to link uniref90 Best hit from representative sequence to each cluster member sequence
#__________________________________________________________________________________________________________________________________________________________________________________________
#Matching uniref90 annotations from representative sequence GeneID to GeneID of each cluster member

import time
import numpy as np


repseqFILE = "annotated_uniref90/MGBC_Genes_clusters_rep_uniref90_TopHit.tsv"
clustermembersFILE = "mmseqs_nuc-linclust_output/MGBC_Genes_clusters.tsv"
uniref2membersFILE = "clustermembers_uniref.txt"
membersnomatchFILE = "clustermembers_unannotated.txt"

print("starting script to match TOPHIT uniref annotations from representative sequences to all cluster members")

clustersARRAY = np.loadtxt(clustermembersFILE, dtype=str, delimiter='\t') # load file with cluster member IDs and matching representative sequence IDs
repseqARRAY = np.loadtxt(repseqFILE, dtype=str, delimiter='\t') #load file with representative sequence IDs of clusters and matching uniref annotations
outARRAY = []
print("CLUSTER and REPSEQ files loaded")

repseqSORTED = np.argsort(repseqARRAY[:,0]) # returns array of indices in the order matching the sorted values (ie index1-> value"C", index2-> value"A", index3-> value"B", returns [index2, index3, index1]
print ("REPSEQ array successfully sorted")

matchsortedINDEX = np.searchsorted(repseqARRAY[:,0], clustersARRAY[:,0], sorter=repseqSORTED) # returns array of indices where each clusterARRAY value would fit in the sorted version of the repseqARRAY
print ("CLUSTER array entries matched to sorted REPSEQ indices")                              # to maintain the sorted order (ie if sorted repseqARRAY = [A, B, C, E] and clusterARRAY = [D, B] would return [3, 1]
                                                                                              # there is no issue here because all values of clustersARRAY[:,0] are all present and unique in repseqARRAY[:,0]
                                                                                              #ACTUALLY THERE IS AN ISSUE!!: some genes in clusters array are absent in repseqARRAY (no hit in uniref_90), leading to spurious matches  


matchunsortedINDEX = np.take(repseqSORTED, matchsortedINDEX)          # uses the sorted matching indices to obtain the corresponding list of original (unsorted) indices in repseqARRAY  
print("CLUSTER array entries matched to original REPSEQ indices")

outARRAY = np.hstack((clustersARRAY, repseqARRAY[matchunsortedINDEX,:])) # adds columns from repseqARRAY that match each line in clustersARRAY to the end of the original clustersARRAY lines 

outARRAY_matches = outARRAY[outARRAY[:,0] == repseqARRAY[matchunsortedINDEX,0]] # makes new array containing only rows where clusterREP is present in the uniref-annotated output (repseqARRAY)
outARRAY_nomatches = outARRAY[outARRAY[:,0] != repseqARRAY[matchunsortedINDEX,0]] # makes new array containing only rows where the clusterREP DID NOT receive a uniref annotation (absent in repseqARRAY)

print ("outARRAY generated, writing to file")

np.savetxt(uniref2membersFILE, outARRAY_matches, fmt = "%s") # writes array to file, can change delimiter in file with " delimeter ="?" " parameter
np.savetxt(membersnomatchFILE, outARRAY_nomatches, fmt = "%s")
