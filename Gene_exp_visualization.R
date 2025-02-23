#script to visualize the data
#upload the library
library(tidyverse)
library(ggplot2)
#bar plot
# Open a data frame in the Source pane

dat.long %>%
  filter(gene=='BRCA1') %>%
  ggplot(.,aes(x= samples, y=FPKM,fill=tissue))+
  geom_col()
#density
dat.long %>%
  filter(gene=='BRCA1') %>%
  ggplot(.,aes(x=FPKM,fill=tissue))+
  geom_density(alpha=0.3)
#boxplot
dat.long%>%
  filter(gene=='BRCA1')%>%
  ggplot(.,aes(x=metstasis,y=FPKM))+
  geom_boxplot()
#we can change the boxplot into violnt plat by chnging the geom_boxplot into geom_violnt()

#scatterplot
dat.long %>%
  filter(gene=='BRCA1'| gene=='BRCA2') %>%
  spread(key= gene,value = FPKM) %>%
  ggplot(.,aes(x=BRCA1,y=BRCA2,color= tissue))+
  geom_point()+
  geom_smooth(method='lm', se =FALSE)
#5 heatmap
genes.of.interst<-c('BRCA1','BRCA2','TP53','ALK','MYCN')
dat.long %>%
  filter(gene %in% genes.of.interst) %>%
  ggplot(.,aes(x=samples,y=gene, fill=FPKM))+
  geom_tile()+
  scale_fill_gradient(low='white',high='red')

ggsave(p, filename='heatmap_saved.pdf',width = 10,height = 8)
