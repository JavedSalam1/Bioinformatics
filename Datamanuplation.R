#script to manipulate the data
#setwd('C:/Users/User/Documents/R projects')
#load the library
library(dplyr)
library(tidyverse)
library(GEOquery)
#read the data
dim(data)
#get metadat
gse<-getGEO(GEO='GSE183947',GSEMatrix = TRUE)
gse
metadat<-pData(phenoData(gse[[1]]))
# View the metadata
head(metadat)
#to get info about some specific colums in the daata we will run this comand
metadat.modified<-metadat %>%
  select(1,10,11,17)%>%
  rename(tissue='characteristics_ch1')%>%
  rename(metstasis='characteristics_ch1.1') %>%
  mutate(tissue=gsub("tissue:","",tissue)) %>%
  mutate(metstasis=gsub("metastasis:","",metstasis)) 

# reshaping data - from wide to long--------
dat.long <- data %>%
  rename(gene = X) %>%
  gather(key = 'samples', value = 'FPKM', -gene)


# join dataframes = dat.long + metadata.modified

dat.long <- dat.long %>%
  left_join(., metadat.modified, by = c("samples" = "description")) 

# explore data ------
# filter, group_by, summarize and arrange 
dat.long %>%
  filter(gene == 'BRCA1' | gene == 'BRCA2') %>%
  group_by(gene, tissue) %>%
  summarize(mean_FPKM = mean(FPKM),
            median_FPKM = median(FPKM)) %>%
  arrange(-mean_FPKM)
  