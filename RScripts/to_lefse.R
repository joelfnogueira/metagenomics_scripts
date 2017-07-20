# author : roshan padmabhan
# date : 18th July 2017

# Aim : This script converts the taxtable created by micca to lefse
# Required  : micca tax table file
#			: qiime mapping / metadata file
#			: class variable
#			: subclass variable
#			: out result file
# CAUTION   : assuming the mapping file have qiime specification and sample is is '#SampleID'

suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("stringr"))
suppressPackageStartupMessages(library("tidyverse"))
#----------------modify here-----------------------------------------

# map_fp="../../pten_mbi_fecal.tsv_corrected.csv"
# taxtable_fp="taxtable2.txt"
# class_var = "Sex"
# subclass_var = "CancerHx"
# res_out_fp="taxtable2_for_lefse.tsv"

#-------------------------------------------------------------------
# create parser object
parser = ArgumentParser()

parser$add_argument("-m", "--map_fp", type="character", help="metadata file path")
parser$add_argument("-d", "--taxtable_fp", type="character", help="distance matrix file path")
parser$add_argument("--class", dest='class_var', type="character", help="Category [column name ] in the metadata file")
parser$add_argument("--subclass", dest='subclass_var', type="character", help="Pattern to subset out in Category")
parser$add_argument("-r", "--res_out_fp", type="character", help="output tax table with class and sublcass for lefse, tsv output")

args = parser$parse_args()
map_fp = args$map_fp
taxtable_fp = args$taxtable_fp
res_out_fp = args$res_out_fp
class_var = args$class_var
subclass_var = args$subclass_var

# process the inputs
df = read.csv(taxtable_fp, sep="\t")
dfmap = read.csv(map_fp, sep="\t")
dfmap_ss = dfmap[c(class_var, subclass_var, "X.SampleID")]
rownames(dfmap_ss) = dfmap_ss$X.SampleID

# transpose the mampping file
dfmpa_ss_t = t(dfmap_ss)
dfmap_ss_t = as.data.frame(dfmpa_ss_t)

# replace ';' with '|' and put it into the rownames
rownames(df) = str_replace( df[,1], pattern=";", replacement="|")
df = df[-1]

# to relative abundance 
df_x = sapply(df, function(x) round( x/sum(x), 10) )
rownames(df_x) = rownames(df)
df_y = rbind(df_x, dfmap_ss_t)

# join the two matrix
dfmap_ss_t_mat = as.matrix(dfmap_ss_t)
df_x_mat = as.matrix(df_x)
if(ncol(dfmap_ss_t_mat) == ncol( df_x_mat) ){
	df_y = as.data.frame(rbind(  dfmap_ss_t_mat , df_x_mat))
	# save the file
	write.table(df_y, res_out_fp, sep="\t", quote=FALSE, col.names=FALSE)
}else{
	print("Matrix Dim don't match...Trouble\n")
}




