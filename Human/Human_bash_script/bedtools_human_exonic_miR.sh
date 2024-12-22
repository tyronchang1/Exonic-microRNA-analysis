#!/bin/bash

#This shell script is written by Tyron Chang
#This shell script will overlap all exonic miRs that are completely contained within exons 
#==================================================

#FIRST, convert gff file from miRbase into tsv file first 
awk -F'\t' 'BEGIN{OFS="\t"} $1 ~ /^#/ {next} {gsub(";", "\t", $9); print $1, $3, $4, $5, $7, $9}' /Users/tyronchang/Desktop/exonic-microrna-analysis/github/Human/Human_miRbase_file/hsa.gff3 > hsa.tsv
#================================================

#Order of the shell scripts to run:

#1.exonic miR shell script
#2.nonoverlap miR script
#3.intronic miR script



#SECOND,convert tsv files into bed files
#This command convert tsv files into bed file
#files without microRNA

awk -F'\t' '{OFS="\t"; print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' human_all_genes_no_miR_df_NCBI.tsv > human_all_genes_no_miR_df_NCBI.bed 


#files with microRNA and convert it into bed file
awk -F'\t' '{OFS="\t"; print $1, $3, $4, $2, $8, $5, $7}' hsa.tsv > hsa.bed ####This data is from miRbase
#### This step is to regoranize columns in hsa.tsv file for python to read 
awk -F'\t' '{OFS="\t"; print $1, $3, $4, $2, $8, $5, $7}' hsa.tsv > hsa_finalized.tsv

####alternatively, you can also use a different miR data derived from NCBI refseq
#awk -F'\t' '{OFS="\t"; print $1, $2, $3, $4, $5, $6, $7, $8}' df_humanmiR_NCBI.tsv > df_human_miR_NCBI.bed
#df_humanmiR_NCBI.tsv contains all miR from NCBI database
#===============================================


#THIRD, Use bedtools to overlap exonic microRNAs and export it as tsv file
#-F 1 flag means 100% overlap of miR to the exon, -s means on the same strand

bedtools intersect -a human_all_genes_no_miR_df_NCBI.bed  -b hsa.bed -s -wa -wb -F 1 >human_exonic_miR_NCBI.bed 

###FOURTH, convert the file bed file into a tsv file.
# this command convert final bed  files into tsv file
awk -F'\t' '{OFS="\t"; print $0}' human_exonic_miR_NCBI.bed>human_exonic_miR_NCBI.tsv

###LASTLY, move all tsv, bed, and gff files into their own folders.

out_dir=$(cd .. && pwd)

mv *.tsv ${out_dir}/Human_tsv_file 
mv *.bed ${out_dir}/Human_bed_file 
