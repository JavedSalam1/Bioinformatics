#upload the libraries

library(GEOquery)
library(affy)
library(tidyverse)
#get the supplementary files
getGEOSuppFiles('GSE148537')
#uncompressed or untar the files
untar("C:/Users/User/Documents/GSE148537/GSE148537_RAW.tar", 
      exdir = "C:/Users/User/Documents/GSE148537")
#read in .cle file
raw_data<-ReadAffy(celfile.path = "C:/Users/User/Documents/GSE148537")
raw_data
#performing rna normaliztion
normalized.data<-rma(raw_data)
normalized.data
#get exprsession estimates
normalized.expr<-as.data.frame(exprs(normalized.data))
#map probes id to gene symbols
gse<-getGEO("GSE148537", GSEMatrix = TRUE)
#fetch feature data to get id gene symbol maping
feature.data<-gse$GSE148537_series_matrix.txt.gz@featureData@data
#subset
feature.data<-feature.data[,c(1,11)]
normalized.expr <- normalized.expr %>%
  rownames_to_column(var = "ID") %>%  # Ensure row names are converted to a column
  inner_join(feature.data, by = "ID")  # Correct syntax for `by`
