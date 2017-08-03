# author : Roshan Padmanbhan
# date : Aug 3 , 2017
# Aim  : join the kegg metagenome patway file (L3) from picrust pipeline and qiime mapping file into lefse format 

source("~/bin/da.R" )

# Kegg patway L3 file
k_fp="kegg_pathway_predictions.L3.txt"
# metadata file in qiime format
md_fp="pten_fecal_with_ccscore.tsv"
# output file
out_fp="kegg_pathway_predictions.L3.forlfese.tsv"

# process mapping file
mdf = read.csv(md_fp, sep="\t")
rownames(mdf) = mdf$X.SampleID

# process kegg predictions file 
df = read.csv(k_fp ,sep="\t", skip=1) 
df = df[-1]
df_d = df[-ncol(df)]
df_l = df[ncol(df)]

# removing the rows where rowSum == 0
toRemove = which(rowSums( df_d)==0)
df_l2 =  as.data.frame( df_l[ -toRemove ,])
df_d2 =  as.data.frame(df_d[ -toRemove ,])
colnames(df_l2) = "KEGG_Pathways"

# to rel ab
df_d2 = sapply(df_d2, function(x){ x/sum(x) })

# mdf %>% dim
# df_d2 %>% dim
# df_l2 %>% dim

rownames(df_d2) = df_l2$KEGG_Pathways
X =  t(cbind(mdf,t(df_d2))  )
X = as.data.frame(X) 
X['Class'] = rownames(X )
X$Class = gsub( '; ','|', X$Class)
rownames(X) = NULL

# rearrange columns
X =  dplyr::select( X , Class,1:(ncol(X)-1 ) ) 

# save
write.table(X, file=out_fp, sep="\t", quote=F, row.names=F)

