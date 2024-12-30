#!/bin/bash

#This shell script is written by Tyron Chang
#This shell script will overlap all exonic miRs that are completely contained within exons 
#==================================================
#convert gff file from miRbase into tsv file first 

mmu_path=$(cd ../Mouse_miRbase_file && pwd)

awk 'BEGIN{OFS="\t"} $1 ~ /^#/ {next} {gsub(";", "\t", $9); print $1, $3, $4, $5, $7, $9}' ${mmu_path}/mmu.gff3 > mmu.tsv

#================================================
#Order of the shell scripts to run:
 #1.exonic miR shell script
 #2.nonoverlap miR script
 #3.intronic miR script

#This command convert tsv fileis into bed file
#files without microRNA

awk -F'\t' '{OFS="\t"; print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' mouse_all_genes_no_miR_df_NCBI.tsv > mouse_all_genes_no_miR_df_NCBI.bed 


#files with microRNA and convert it into bed file
awk -F'\t' '{OFS="\t"; print $1, $3, $4, $2, $8, $5, $7}' mmu.tsv > mmu.bed

#### This step is to regoranize columns in hsa.tsv file for python to read 
awk -F'\t' '{OFS="\t"; print $1, $3, $4, $2, $8, $5, $7}' mmu.tsv > mmu_finalized.tsv

####alternatively, you can also use a different miR data derived from NCBI refseq
#awk -F'\t' '{OFS="\t"; print $1, $2, $3, $4, $5, $6, $7, $8}' df_mousemiR_NCBI.tsv > df_mouse_miR_NCBI.bed

#===============================================
#Using bedtools to overlap exonic microRNAs and export it as tsv file
#-F 1 flag means 100% overlap of miR to the exon, -s means on the same strand

bedtools intersect -a mouse_all_genes_no_miR_df_NCBI.bed  -b mmu.bed -s -wa -wb -F 1 >mouse_exonic_miR_NCBI.bed 

# this command convert final bed  files into tsv file
awk -F'\t' '{OFS="\t"; print $0}' mouse_exonic_miR_NCBI.bed>mouse_exonic_miR_NCBI.tsv

###LASTLY, move all tsv, bed, and gff files into their own folders.
 
out_dir=$(cd .. && pwd)
 
mv *.tsv ${out_dir}/Mouse_tsv_file
mv *.bed ${out_dir}/Mouse_bed_file
