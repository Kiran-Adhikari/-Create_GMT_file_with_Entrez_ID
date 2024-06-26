#!/bin/bash

##Download data for E. coli MG1655 
curl -O https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa

# count the number of sequences in the file
seq_in_file=$(grep "^>" NC_000913.faa | wc -l) 

echo "The number of sequences in the file : $seq_in_file"

## total number of amino acids
total_no_aa=$(grep -v '^>' NC_000913.faa | tr -d '\n' | wc -m)

echo "The total number of amino acids in the file : $total_no_aa"

# The average length of protein in E. coli MG1655 strain 
average_length=$(echo "scale=0; $total_no_aa / $seq_in_file" | bc)

echo "The average length of protein in E. coli MG1655 strain : $average_length"
