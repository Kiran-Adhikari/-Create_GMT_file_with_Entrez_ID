library(ggplot2)
library(dplyr)

# Read the data file
file_path <- "Homo_sapiens.gene_info"
gene_info <- read.delim(file(file_path), header = TRUE, stringsAsFactors = FALSE)

## Checking column chromosome
#unique(gene_info$chromosome)

## getting column 3 and 7 and filtering - and | 
subset_gene_info <- gene_info %>%
  filter(!grepl("[\\|-]", chromosome)) %>%
  select(Symbol, chromosome)

## Checking column chromosome in new dataframe
#unique(subset_gene_info$chromosome)

## Counting no of gene in each chrosome
gene_counts <- subset_gene_info %>% count(chromosome)

# chromosome order as strings
chr_order <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", 
               "13", "14", "15", "16", "17", "18", "19", "20", "21", "22",
               "X", "Y", "MT", "Un")

# Converting the chromosome column to character
gene_counts$chromosome <- as.character(gene_counts$chromosome)

# Converting chromosome column to factor using chr order 
gene_counts$chromosome <- factor(gene_counts$chromosome, levels = chr_order)

# Order the gene_counts at chromososme level
gene_counts_sorted <- gene_counts[order(gene_counts$chromosome), ]

# view final sorted file
#print(gene_counts_sorted)

## Plotting Bar graph 
plt <- ggplot(gene_counts_sorted, aes(x=chromosome, y = n)) +
  geom_bar(stat="identity")  +
  labs(title="Number of genes in each chromosome",
       x ="Chromosomes", y = "Gene count") +
  theme_classic()

##Save as pdf
ggsave("No_of_gene_VS_chr.pdf", plt)

## 
if (file.exists("No_of_gene_VS_chr.pdf")) {
  message(" Number of genes in each chromosome plot is saved as  '", "No_of_gene_VS_chr.pdf", " successfully.")
}
