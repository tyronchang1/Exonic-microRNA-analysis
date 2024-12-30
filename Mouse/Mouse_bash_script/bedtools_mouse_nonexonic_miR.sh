#!/bin/bash

#==========
#Using bedtools to find nonexonic microRNAs with and export it as tsv file
#-v means find all the nonoverlapped regions -F 1 flag means 100% overlap of miR to the exon, -s means on the same strand
# This command will find all the nonexonic microRNAs (intronic and nonhostgene ones)

#Order of the shell script:
 #1 exonic shell script
 #2 nonoverlap shell script
 #3 intronic shell script

#This command will find all the nonexonic microRNAs (intronic and nonhostgene ones)

cd ../Mouse_bed_file

bedtools intersect -a mmu.bed -b mouse_all_genes_no_miR_df_NCBI.bed -v >mouse_nonexonicmiR_NCBI.bed 

#### This command will get exonic miRNAs on the same strand as host genes. However,miRNAs partial    ly overlapped with the exons will be included.
bedtools intersect -a mouse_all_genes_no_miR_df_NCBI.bed -b mmu.bed -s -wa -wb >mouse_exonic_miR_intragenic_NCBI.bed

#this command will find the ones opposite to the host mRNAs
bedtools intersect -a mouse_all_genes_no_miR_df_NCBI.bed -b mmu.bed -S -wa -wb >mouse_exonic_miR_opposite_NCBI.bed 


# this command convert final bed  files into tsv file
awk -F'\t' '{OFS="\t"; print $0}' mouse_nonexonicmiR_NCBI.bed>mouse_nonexonicmiR_NCBI.tsv
awk -F'\t' '{OFS="\t"; print $0}' mouse_exonic_miR_opposite_NCBI.bed>mouse_exonic_miR_opposite_NCBI.tsv

awk -F'\t' '{OFS="\t"; print $0}' mouse_exonic_miR_intragenic_NCBI.bed>mouse_exonic_miR_intragenic_NCBI.tsv

#Append the opposite stranded microRNAs onto the original files
#awk -F'\t' '{OFS="\t"; print $9, $10, $11, $12, $13, $14, $15}' mouse_nonoverlapmiR_NCBI_opposite_strand_metadata.tsv>>mouse_nonoverlapmiR_NCBI.tsv


###LASTLY, move all tsv, bed, and gff files into their own folders.
 
out_dir=$(cd .. && pwd)
 
mv mouse_nonexonicmiR_NCBI.tsv ${out_dir}/Mouse_tsv_file
mv mouse_exonic_miR_opposite_NCBI.tsv ${out_dir}/Mouse_tsv_file
mv mouse_exonic_miR_intragenic_NCBI.tsv ${out_dir}/Mouse_tsv_file
