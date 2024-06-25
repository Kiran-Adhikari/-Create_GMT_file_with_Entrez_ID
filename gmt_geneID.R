##Set path to Directory
setwd("/Users/kiranadhikari/Downloads/kmu")

## Loading libary
library(GSA)
library(dplyr)
library(tidyr)


##Loading gmt file
gmt_file <- ("h.all.v2023.1.Hs.symbols.gmt")
##Reading GMT file
gmt_symbols_file <- GSA.read.gmt(gmt_file)

### Loading the gene_info file
gene_info <- ("Homo_sapiens.gene_info") 

## Loading Human gene info file
Homo_spiens_gene_info <- read.delim(gene_info, header = TRUE, sep = "\t")

## Checking data inside files
#head(gmt_symbols_file$geneset.names)
#head(gmt_symbols_file$genesets)
#head(Homo_spiens_gene_info)


##Creating subset with 2,3 and 5 columns from gene_info file
subset_Homo_spiens_gene_info <- Homo_spiens_gene_info[, c("GeneID", "Symbol", "Synonyms")]

#View(subset_Homo_spiens_gene_info)

# Split synonyms from Homo_spiens_gene_info and assign GeneID to each synonym
split_gene_symbols <- subset_Homo_spiens_gene_info %>%
  separate_rows(Synonyms, sep = "\\|")

# View the results from  data frame
#head(split_gene_symbols)
#tail(split_gene_symbols)

## creating a new with synomyns and GeneId and removing rows with "-" in symbols
## and change col name Synonyms to Symbol
synonyms <- split_gene_symbols[,c("GeneID", "Synonyms")] %>%
  filter(Synonyms != "-") %>%
  rename(Symbol = Synonyms )

## Checking some rows
#synonyms[synonyms$GeneID == 130890644, ]
#subset_Homo_spiens_gene_info[subset_Homo_spiens_gene_info$GeneID == 130890644, ]

## Combining symbols and synonyms into one dataframe 
## OR Adding column of synonyms with geneID to the Symbol to create GeneId map

# Creating df with symbol from gene_info file
gene_symbols <- Homo_spiens_gene_info[, c("GeneID", "Symbol")]

## combine 
gene_ID_map <- rbind(gene_symbols, synonyms)

## Sorted according geneID
gene_ID_map <- gene_ID_map %>% arrange(GeneID)

#View final gene_id MAP
#head(gene_ID_map)

##Checking for dimensions
#dim(gene_symbols)
#dim(synonyms)
#dim(gene_ID_map)
# View(gene_ID_map)

#____________________#
# Replace gene symbols with IDs

#read gmt file
lines <- readLines(gmt_file)


# Modify each line based on gene_ID_map
for (i in seq_along(lines)) {
  for (j in seq_len(nrow(gene_ID_map))) {
    lines[[i]] <- gsub(paste0("\\<", gene_ID_map[j, "Symbol"], "\\>"), gene_ID_map[j, "GeneID"], lines[[i]])
  }
}

# New gmt file name
new_gmt_file <- "Pathway_Entrez_ID.gmt"

#  Write modified lines to the new GMT file
writeLines(lines, new_gmt_file)

##View final new gmt file replaced with Entrez_ID
#new_gmt_symbols_file <- GSA.read.gmt(new_gmt_file)
#head(new_gmt_symbols_file$genesets)


if (file.exists(new_gmt_file)) {
  message("New gmt File '", new_gmt_file, "' created successfully.") 
  }
  
  
  
  

