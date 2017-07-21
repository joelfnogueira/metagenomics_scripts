# author : roshan padmanabhan
# date : July 20th 2017
suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("tidyverse"))

# Aim : Subsetting the Distance Matrix file from qiime betadiv output
# 		The subsetted distance matrix can be used for compare_categories.py 
# Required  :
# Mapping file
# distance file
# subsetted distance res file
# subsetted metadata res file 
# var_char = 'Sex'
# pat = 'F'

# create parser object
parser = ArgumentParser()

parser$add_argument("-m", "--map_fp", type="character", help="metadata file path")
parser$add_argument("-d", "--dist_fp", type="character", help="distance matrix file path")
parser$add_argument("-x", "--res_map_fp", type="character", help="subsetted metadata out file path")
parser$add_argument("-y", "--res_dist_fp", type="character", help="substetted distance matrix out file path")

parser$add_argument("--category", dest='var_char', type="character", help="Category [column name ] in the metadata file")
parser$add_argument("--pattern", dest='pat', type="character", help="Pattern to subset out in Category")


# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
args = parser$parse_args()
map_fp = args$map_fp
dist_fp = args$dist_fp
res_map_fp = args$res_map_fp
res_dist_fp = args$res_dist_fp
var_char = args$var_char
pat = args$pat

#---------------------------------------------------------------------------------------------

map_df = read.csv(map_fp , sep="\t" ) 
# Get the SampleIDs where Sex is F
subsetted_map = map_df[ map_df[var_char] == pat, ]
only_pat = as.character(subsetted_map$X.SampleID )
subsetted_map = subsetted_map %>% dplyr::rename( "#SampleID" = X.SampleID ) 
# Get the distance matrix as matrix object
df = read.table(dist_fp, sep="\t", header=T , row.names=1)
df = as.matrix( df ) 

# Subset the matrix 
subsetted_dist = df[only_pat ,only_pat]
# Save new map and disr file
write_tsv(subsetted_map , res_map_fp )
write.table(subsetted_dist, res_dist_fp, sep="\t", quote=FALSE) 
# Done
