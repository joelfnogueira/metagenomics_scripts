# micca_metagneomics

- contains scripts for a hybrid qiime 1.9 / micca 16s amplicone pipeline

### to_lefse.R : script to convert the micca taxtable to lefse input files
```
usage: to_lefse.R [-h] [-m MAP_FP] [-d TAXTABLE_FP] [--class CLASS_VAR]
                  [--subclass SUBCLASS_VAR] [-r RES_OUT_FP]

optional arguments:
  -h, --help            show this help message and exit
  -m MAP_FP, --map_fp MAP_FP
                        metadata file path
  -d TAXTABLE_FP, --taxtable_fp TAXTABLE_FP
                        distance matrix file path
  --class CLASS_VAR     Category [column name ] in the metadata file
  --subclass SUBCLASS_VAR
                        Pattern to subset out in Category
  -r RES_OUT_FP, --res_out_fp RES_OUT_FP
                        output tax table with class and sublcass for lefse,
                        tsv output
```
### subset_distance_matrix_and_metadata_category.R  : for qiime 1.9 betadiv distance matrix subsetting 
```
usage: subset_distance_matrix_and_metadata_category.R [-h] [-m MAP_FP]
                                                           [-d DIST_FP]
                                                           [-x RES_MAP_FP]
                                                           [-y RES_DIST_FP]
                                                           [--category VAR_CHAR]
                                                           [--pattern PAT]

optional arguments:
  -h, --help            show this help message and exit
  -m MAP_FP, --map_fp MAP_FP
                        metadata file path
  -d DIST_FP, --dist_fp DIST_FP
                        distance matrix file path
  -x RES_MAP_FP, --res_map_fp RES_MAP_FP
                        subsetted metadata out file path
  -y RES_DIST_FP, --res_dist_fp RES_DIST_FP
                        substetted distance matrix out file path
  --category VAR_CHAR   Category [column name ] in the metadata file
  --pattern PAT         Pattern to subset out in Category
```
