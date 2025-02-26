#script to perform differential gene exp using ddseq2
#load libraries
library(DESeq2)
library(tidyverse)
library(airway)
#preparing count data
counts_data<-read.csv('counts_data.csv')
colum_data<-read.csv('sample_info.csv')
#make sure that the colum name in the colum data should be same to colum names in counts data
all(colnames(counts_data) %in% row.names(colum_data))
#are they all in same order?
all(colnames(counts_data)==rownames(colum_data))
#construct deseq2 dataset objet
dds<-DESeqDataSetFromMatrix(countData =counts_data,
                            colData=colum_data,
                            design = ~ dexamethasone)
#prefiltering the rows which have low gene counts
# and persist have rows that have 10 reads
keep<-rowSums(counts(dds)) >=10
dds<-dds[keep,]
dds
#set the factor change
dds$dexamethasone <- relevel(dds$dexamethasone, ref = "untreated")
# NOTE: collapse technical replicates

# Step 3: Run DESeq ----------------------
dds <- DESeq(dds)
res <- results(dds)

res



# Explore Results ----------------

summary(res)

res0.01 <- results(dds, alpha = 0.01)
summary(res0.01)

# contrasts
resultsNames(dds)

# e.g.: treated_4hrs, treated_8hrs, untreated

results(dds, contrast = c("dexamethasone", "treated_4hrs", "untreated"))

# MA plot
plotMA(res)
