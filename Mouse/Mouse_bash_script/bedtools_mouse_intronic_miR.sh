#!/bin/bash

#this file will map all intronic miRs
#change tsv file in to bed file
#human_all_genes_no_miR_df_TX_loc_NCBI.tsv is a file with transcription start and end coordinates instead of exon coordinates
# mouse_nonexonicmiR_NCBI.bed contains all miRNAs that are either intronic or nonhost genes miRNAs.

out_dir=$(cd .. && pwd)

cd ../Mouse_tsv_file


awk -F '\t' '{print $0}' mouse_all_genes_no_miR_df_TX_loc_NCBI.tsv> mouse_all_genes_no_miR_df_TX_loc_NCBI.bed 

mv mouse_all_genes_no_miR_df_TX_loc_NCBI.bed ${out_dir}/Mouse_bed_file

cd ../Mouse_bed_file

### This command will find all the intronic micrornas
bedtools intersect -a mouse_all_genes_no_miR_df_TX_loc_NCBI.bed -b mouse_nonexonicmiR_NCBI.bed -s -wa -wb >mouse_intronic_miR_NCBI.bed
awk -F'\t' '{OFS="\t"; print $0}' mouse_intronic_miR_NCBI.bed>mouse_intronic_miR_NCBI.tsv


bedtools intersect -a mouse_all_genes_no_miR_df_TX_loc_NCBI.bed -b mouse_nonexonicmiR_NCBI.bed -wa -wb >mouse_intronic_miR_intragenic_NCBI.bed
awk -F'\t' '{OFS="\t"; print $0}' mouse_intronic_miR_intragenic_NCBI.bed>mouse_intronic_miR_intragenic_NCBI.tsv



#this command will find the miRNAs without host mRNAs
bedtools intersect -a mouse_nonexonicmiR_NCBI.bed -b mouse_all_genes_no_miR_df_TX_loc_NCBI.bed -v >mouse_miR_no_hostmRNA_NCBI.bed

# this command convert final bed  files into tsv file
awk -F'\t' '{OFS="\t"; print $0}' mouse_miR_no_hostmRNA_NCBI.bed>mouse_miR_no_hostmRNA_NCBI.tsv

#Append the opposite stranded microRNAs onto the files with miRs that do not have host mRNA
#awk -F'\t' '{OFS="\t"; print $1, $2, $3, $4, $5, $6, $7}' mouse_nonexonicmiR_NCBI_opposite_strand_metadata.tsv>>mouse_miR_no_hostmRNA_NCBI.tsv

bedtools intersect -a mouse_all_genes_no_miR_df_TX_loc_NCBI.bed -b mouse_nonexonicmiR_NCBI.bed -S -wa -wb >mouse_intronic_opposite_miR_NCBI.bed
awk -F'\t' '{OFS="\t"; print $0}' mouse_intronic_opposite_miR_NCBI.bed>mouse_intronic_opposite_miR_NCBI.tsv
#awk -F'\t' '{OFS="\t"; print $9, $10, $11, $12, $13, $14, $15}' mouse_intronic_opposite_miR_NCBI.tsv>>mouse_miR_no_hostmRNA_NCBI.tsv

mv *.tsv ${out_dir}/Mouse_tsv_file
