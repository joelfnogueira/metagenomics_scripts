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
### micca_modify_tax_txt_v5.py : convert the micca biom to green genes style format
```
usage: micca_modify_tax_txt_v5.py [-h] -i TSV_FILE -o OUT_FILE

    this script modifies the biom tsv file created by micca pipeline into greengenes style format
    # input  :  otu_table.tsv
    #  Constructed from biom file
    # OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F  MPN23F  MPN29F  MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
    # 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 Bacteria; Firmicutes; Bacilli; Lactobacillales; Enterococcaceae; Enterococcus
     
    # output  : otu_table_modified.tsv 
    #  Constructed from biom file
    # OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F  MPN23F  MPN29F  MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
    # 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 k__Bacteria;p__Firmicutes;c__Bacilli;o__Lactobacillales;f__Enterococcaceae;g__Enterococcus;
 
    

optional arguments:
  -h, --help   show this help message and exit
  -i TSV_FILE  micca_otu_table.tsv
  -o OUT_FILE  micca_out_table_modified.tsv

```




