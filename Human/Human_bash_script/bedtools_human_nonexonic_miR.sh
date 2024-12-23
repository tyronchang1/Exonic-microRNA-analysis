#!/bin/bash

#==========
#Using bedtools to find nonexonic microRNAs with and export it as tsv file
#-v means find all the nonoverlapped regions -F 1 flag means 100% overlap of miR to the exon, -s means on the same strand

#====================================
#Order of the shell script:
#1 exonic shell script
#2 nonoverlap shell script
#3 intronic shell script

# This command will find all the nonexonic microRNAs (intronic and nonhostgene ones)

cd ../Human_bed_file  
bedtools intersect -a hsa.bed -b human_all_genes_no_miR_df_NCBI.bed -v >human_nonexonicmiR_NCBI.bed 

#this command will find the ones opposite to the host mRNAs but still exonic miRNAs
bedtools intersect -a human_all_genes_no_miR_df_NCBI.bed -b hsa.bed -S -wa -wb >human_exonic_miR_opposite_NCBI.bed 
#### This command will get exonic miRNAs on the same strand as host genes. However,miRNAs partially overlapped with the exons will be included.
bedtools intersect -a human_all_genes_no_miR_df_NCBI.bed -b hsa.bed -s -wa -wb >human_exonic_miR_intragenic_NCBI.bed 


# this command convert final bed  files into tsv file
awk -F'\t' '{OFS="\t"; print $0}' human_nonexonicmiR_NCBI.bed>human_nonexonicmiR_NCBI.tsv
awk -F'\t' '{OFS="\t"; print $0}' human_exonic_miR_opposite_NCBI.bed>human_exonic_miR_opposite_NCBI.tsv
awk -F'\t' '{OFS="\t"; print $0}' human_exonic_miR_intragenic_NCBI.bed>human_exonic_miR_intragenic_NCBI.tsv

#awk -F'\t' '{OFS="\t"; print $9, $10, $11, $12, $13, $14,$15}' human_nonoverlapmiR_NCBI_opposite_strand_metadata.bed>human_nonoverlapmiR_NCBI_opposite_strand_metadata.tsv

#Append the opposite stranded microRNAs onto the original files
#awk -F'\t' '{OFS="\t"; print $9, $10, $11, $12, $13, $14, $15}' human_nonoverlapmiR_NCBI_opposite_strand_metadata.tsv>>human_nonoverlapmiR_NCBI.tsv


###LASTLY, move all tsv, bed, and gff files into their own folders.
 
out_dir=$(cd .. && pwd)

mv human_nonexonicmiR_NCBI.tsv ${out_dir}/Human_tsv_file
mv human_exonic_miR_opposite_NCBI.tsv ${out_dir}/Human_tsv_file
mv human_exonic_miR_intragenic_NCBI.tsv ${out_dir}/Human_tsv_file  
