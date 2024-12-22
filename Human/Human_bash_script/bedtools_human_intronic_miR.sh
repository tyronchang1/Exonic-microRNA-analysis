#!/bin/bash

#change tsv file in to bed file
#human_all_genes_no_miR_df_TX_loc_NCBI.tsv is a file with transcription start and end coordinates instead of exon coordinates
# human_nonexonicmiR_NCBI.bed contains all miRNAs that are either intronic or nonhost genes miRNAs.

out_dir=$(cd .. && pwd)
cd ../Human_tsv_file
awk -F '\t' '{print $0}' human_all_genes_no_miR_df_TX_loc_NCBI.tsv> human_all_genes_no_miR_df_TX_loc_NCBI.bed 

mv human_all_genes_no_miR_df_TX_loc_NCBI.bed ${out_dir}/Human_bed_file

cd ../Human_bed_file
### This command will find all the intronic micrornas, but same strands (sense).
bedtools intersect -a human_all_genes_no_miR_df_TX_loc_NCBI.bed -b human_nonexonicmiR_NCBI.bed -s -wa -wb >human_intronic_miR_NCBI.bed
awk -F'\t' '{OFS="\t"; print $0}' human_intronic_miR_NCBI.bed>human_intronic_miR_NCBI.tsv


### This command will find all the intronic micrornas regardless of the transcriptional orientations
bedtools intersect -a human_all_genes_no_miR_df_TX_loc_NCBI.bed -b human_nonexonicmiR_NCBI.bed -wa -wb >human_intronic_miR_intragenic_NCBI.bed
awk -F'\t' '{OFS="\t"; print $0}' human_intronic_miR_intragenic_NCBI.bed>human_intronic_miR_intragenic_NCBI.tsv


#this command will find the miRNAs without host  mRNAs
bedtools intersect -a human_nonexonicmiR_NCBI.bed -b human_all_genes_no_miR_df_TX_loc_NCBI.bed -v >human_miR_no_hostmRNA_NCBI.bed

# this command convert final the bed  file into tsv file
awk -F'\t' '{OFS="\t"; print $0}' human_miR_no_hostmRNA_NCBI.bed>human_miR_no_hostmRNA_NCBI.tsv

#Append the opposite stranded microRNAs onto the files with miRs that do not have host mRNA
#awk -F'\t' '{OFS="\t"; print $1, $2, $3, $4, $5, $6, $7}' human_nonoverlapmiR_NCBI_opposite_strand_metadata.tsv>>human_miR_no_hostmRNA_NCBI.tsv

#This will extract all the antisense intronic miRNAs.
bedtools intersect -a human_all_genes_no_miR_df_TX_loc_NCBI.bed -b human_nonexonicmiR_NCBI.bed -S -wa -wb >human_intronic_opposite_miR_NCBI.bed
awk -F'\t' '{OFS="\t"; print $0}' human_intronic_opposite_miR_NCBI.bed>human_intronic_opposite_miR_NCBI.tsv

#awk -F'\t' '{OFS="\t"; print $9, $10, $11, $12, $13, $14, $15}' human_intronic_opposite_miR_NCBI.tsv>>human_miR_no_hostmRNA_NCBI.tsv


mv *.tsv ${out_dir}/Human_tsv_file
