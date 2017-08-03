# author : Roshan Padmanbhan
# date :  Aug 3 , 2017
# Aim  : join the kegg metagenome predictions file from picrust and qiime mapping file into lefse format 


source("~/bin/da.R" )

# KEGG metagenome prediction file
k_fp="kegg_metagenome_prediction.txt"
# metadata file  in qiime format
md_fp="pten_fecal_with_ccscore.tsv"
# output file
out_fp="kegg_metagenome_predictions.forlfese.tsv"


# process mapping file
mdf = read.csv(md_fp, sep="\t")
rownames(mdf) = mdf$X.SampleID

# process kegg predictions file 
df = read.csv(k_fp ,sep="\t", skip=1) 
df_d = df[-1]
df_l = df[1]

# removing the rows where rowSum == 0
toRemove = which(rowSums( df_d)==0)
df_l2 =  as.data.frame( df_l[ -toRemove ,])
df_d2 =  as.data.frame(df_d[ -toRemove ,])
colnames( df_l2)  = colnames( df_l )

# to rel ab
df_d2_rab = sapply(df_d2, function(x){ x/sum(x) })

# adding rownames to df_d2 | df_d2_rab
rownames( df_d2_rab ) = as.char(df_l2$X.OTU.ID)

# Merging togather two data frames
X =  t(cbind(mdf,t(df_d2_rab))  )
X = as.data.frame(X) 
X['Class'] = rownames(X )
rownames(X) = NULL
# rearrange columns
X =  dplyr::select( X , Class,1:(ncol(X)-1 ) ) 
write.table(X, file=out_fp, sep="\t", quote=F, row.names=F)
