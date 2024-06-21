#!/bin/bash

#SBATCH -n 4
#SBATCH -t 96:00:00
#SBATCH --mem=8G


### THE PURPOSE OF THIS SCRIPT IS TO OBTAIN THE MOST COMPLETE MAPPING OF UNIREF_90 GENE FAMILIES TO ENZYMES (EC#) FOR PATHWAY MAPPING WITH HUMANN3###
###
###     I REALIZED THERE IS AN ISSUE BECAUSE THE UNIREF CLUSTERS ARE REGULARLY UPDATED AND REPRESENTATIVE UNIREF90 ENTRIES OF A GIVEN CLUSTER MAY CHANGE
###     OVER TIME. THIS IS PROBLEMATIC AS HUMANN3 PATHWAY MAPPING IS BASED ON UNIREF2019_1 AND THE MGBC SEQUENCES WERE MAPPED WITH MMSEQS2 TO UNIREF2022_1
###     THIS MEANS SOME UNIREF90 CLUSTERS IN THE MGBC-DATABSE MAY NO LONGER HAVE THE SAME REPRESENTATIVE AS THAT USED IN HUMANN3 MAPPING FILES
###     AND THEREFORE MAY NOT BE PROPERLY MAPPED TO METACYC REACTIONS. 
###     
###     THIS SCRIPT WILL TAKE THE UNIPROT ID FOR EACH UNIREF_90 REPRESENTATIVE (UNIPROT-id = UNIREF90-id WITHOUT THE "uniref90_" PREFIX)
###     FROM THE HUMANN3 GENEFAMILIES OUTPUT FILE AND SEARCH THEM AGAINST THE CURRENT UNIPROT DATABASE TO RETURN ANY EC# ANNOTATION LINKED TO EACH GENE 
###     AND GENERATE A NEW MAPPING FILE WITH EACH LINE CONTAINING A UNIPROT_id AND ASSOCIATED EC# (IF IT HAS ONE). THE RESULTING FILE WILL THEN BE USED TO LINK
###     EACH GENEFAMILY TO A METACYC REACTION BY CALLING THE "map_uniref90-2-metacycRXN.py" PYTHON SCRIPT TO GENERATE A FINAL GENEFAMILY-TO-METACYCRXN MAPPING FILE.
###     THIS NEW MAPPING FILE CAN THEN BE USED WITH HUMANN3 TO PERFORM RXN AND PATHWAY MAPPING


###     NOTE: REMOVE ANY UNIREF90-id THAT ONLY HAS A UNIPARC ID PRIOR TO RUNNING SCRIPT (UPIxxxxxx...) AS UNIPARC ENTRIES HAVE NO ANNOTATIONS ANYWAY AND SO ARE NOT USEFUL

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# line to generate list of uniprotIDs from all uniref gene families in humann3 gene_families output file (JOINED, with humann_join_tables script first) 
# by removing UniRef90_ prefix: (change filenames as necessary)
#awk -F "\t" '{print $1}' humann3_outfiles/unstratified_tables/GImapping-Amox_compiled_genefamilies_unstratified.tsv | awk -F "_" '{print $2}' > uniprot_ids.txt
#---------------------------------------------------------------------------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#below loops through list of uniprotIDs, searches uniprot.org for the entry and returns the same uniprotID along with an EC# (if it is annotated with one, otherwise blank)
# if statement to determine if it is the first ID in the list to format output file (remove header for subsequent search returns)

entry_count=286129  # reset to line number of last uniprotID searched (in case of disconnection and the run needs to be restarted)

while IFS= read -r entry || [[ -n "$entry" ]]; do
    echo "https://rest.uniprot.org/uniprotkb/search?query=${entry}&format=tsv&fields=accession,ec"
    if [ $entry_count == 0 ]; then
        curl "https://rest.uniprot.org/uniprotkb/search?query=${entry}&format=tsv&fields=accession,ec" > map_uniprot2ec.txt
    else
        curl "https://rest.uniprot.org/uniprotkb/search?query=${entry}&format=tsv&fields=accession,ec" | tail -n +2 >> map_uniprot2ec.txt  # remove header with tail  
    fi
    ((entry_count=entry_count+1))
done < "uniprot_ids_329197-332928.txt"
echo $entry_count


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Add back uniref90 prefix to IDs for next step mapping uniref90 entries to metacyc reactions (using EC# to connect them)

sed -n -E 's/(.*)\t(.*)/UniRef90_\1\t\2/;p' map_uniprot2ec.txt > map_uniref90-2022-1_level4ec.txt
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------



###--------------------------------These commands reformat the file containing UniRef Genefamily IDs and associated EC# annotations (generated above) ----------------------------------

awk '$2 != ""' map_uniref90-2022-1_level4ec.txt > map_uniref90-2022-1_level4ec_filtered.txt                      # remove rows with UniRef IDs lacking an EC# annotation (these are not useful)
sed -e 's/; /\t/g;' map_uniref90-2022-1_level4ec_filtered.txt > map_uniref90-2022-1_level4ec_filtered_tabs.txt    # for UniRef IDs with multiple EC annotations separate each EC# into new tab sep column
                                                                                                                  # (instead of "; " separator)
###------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



###-----These commands extract the EC#'s from the "map_metacyc-rxn_name.txt" file provided in humann3 github and reformat with metacyc-RXNs and matching EC# annotations in separate tab-sep columns ----

#sed -n -E 's/(.*)\t.*\[(.*)\]/\1\t\2/;p' map_metacyc-rxn_name.txt > map_level4ec_metacyc-RXN.txt  # collect RXN and EC (from name) per metacyc-RXN and write to new file as tab-sep columns
#sed -e 's/; /\t/g;' map_level4ec_metacyc-RXN.txt > map_level4ec_metacyc-RXN_tabs.txt               # separate multiple ECs by tab (replace ";" separator)   

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


###-------------------------------This script merges the 2 mapping files above and outputs a mapping file linking each metacycRXN to all associated genefamilies, use this final output file in Humann3 mapping ---------------------------

python map_uniref90-2-metacycRXN.py

###------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
