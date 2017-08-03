# Bash script for running the MICCA OPEN REF OTU PICKING in docker
# 
# Author : roshan padmanabhan
#
# Running MICCA -v 01
# Date : July 5, 2017
# CAUTION : this script can also be used in combination with the split lib seqs.modified.fasta file as input
#         : this scipt can also be used if using the native micca pipeline.
# 
# As the muscle took long time I killed it and then use only the pynast aligned for creating msa and subsequently tree building
################################ MODIFY HERE ####################################
# scripts
micca_modify_tsv_fasta_v01="micca_modify_tsv_fasta_v01.py"

# constants
ref97_fas="database/13_8_97_otus.fasta"
ref97_tax="database/13_8_97_otu_taxonomy.txt"
cor_fas="database/core_set_aligned.fasta.imputed"

# locations 
loc="/micca/Fecal02"
in_fas="/micca/Fecal02/modified_seqs.fna"
map_file="/micca/Fecal02/pten_fecal.tsv"
################################################################################

# logging
log_file=$loc/logging.md
touch $log_file

echo -ne  "No of Reads in the fastq file : " >>$log_file  ; grep ">" -c $in_fas >> $log_file

echo "------------------Open refernece OTU Picking--------------" 2>&1 | tee  >>$log_file
micca otu -m open_ref -i  $in_fas -o $loc/open_ref_otus -r $ref97_fas -d 0.97 -t 30 -c
# Run the micca_modify_tsv_fasta_v01.py script .
python $micca_modify_tsv_fasta_v01 -i $loc/open_ref_otus/otuids.txt -t $loc/open_ref_otus/otutable.txt -f $loc/open_ref_otus/otus.fasta -x $loc/open_ref_otus/otuids_modified.txt -y $loc/open_ref_otus/otutable_modified.txt  -z $loc/open_ref_otus/otus_modified.fasta
echo "basic stats on the otu picking output files : "  >>$log_file
echo -ne "No of seqs in the output fasta files " >>$log_file ; grep ">" -c $loc/open_ref_otus/*.fasta >>$log_file 
wc -l $loc/open_ref_otus/*.txt >>$log_file
echo " " >>$log_file

echo "------------------Assign Taxonomy--------------" 2>&1 | tee  >>$log_file 
micca classify -m rdp -i $loc/open_ref_otus/otus_modified.fasta -o $loc/open_ref_otus/taxa_rdp_97.txt --rdp-gene 16srrna --rdp-maxmem 20 --rdp-minconf 0.97 
micca classify -m rdp -i $loc/open_ref_otus/otus_modified.fasta -o $loc/open_ref_otus/taxa_rdp_80.txt --rdp-gene 16srrna --rdp-maxmem 20 --rdp-minconf 0.80 
echo "basic stats on the  : "  >>$log_file
echo -ne "No of lines in  taxonomy files : " >>$log_file  ; wc -l $loc/open_ref_otus/taxa_rdp_97.txt  >> $log_file
echo " " >>$log_file
echo -ne "No of lines in  taxonomy files : " >>$log_file  ; wc -l $loc/open_ref_otus/taxa_rdp_80.txt  >> $log_file
echo " " >>$log_file
echo "------------------MSA with NAST and MUSCLE--------------" 2>&1 | tee  >>$log_file 
micca msa -m nast -i $loc/open_ref_otus/otus_modified.fasta -o $loc/open_ref_otus/msa_nast_coreset.fasta --nast-template $cor_fas --nast-threads 30 --nast-id 0.97
micca msa -m muscle -i $loc/open_ref_otus/otus_modified.fasta -o $loc/open_ref_otus/msa_muscle.fasta
#micca msa -m muscle -i $loc/open_ref_otus/otus_modified.fasta -o $loc/open_ref_otus/msa_muscle.fasta -maxiters 1 -diags1 -sv 

echo "------------------Tree Construction for UNIFRAC -------------" 2>&1 | tee  >>$log_file 
micca tree -i $loc/open_ref_otus/msa_nast_coreset.fasta -o $loc/open_ref_otus/tree_nast.tree
micca tree -i $loc/open_ref_otus/msa_muscle.fasta -o $loc/open_ref_otus/tree_muscle.tree -m muscle
echo "------------------Root the Tree -------------" 2>&1 | tee  >>$log_file 
micca root -i $loc/open_ref_otus/tree_nast.tree -o $loc/open_ref_otus/tree_nast_rooted.tree
micca root -i $loc/open_ref_otus/tree_muscle.tree -o $loc/open_ref_otus/tree_muscle_rooted.tree

#Error: maximum recursion depth exceeded while calling a Python object

echo "------------------Summarize Communities by their Taxonomic composition --------------"  2>&1 | tee  >>$log_file 
# summarize communities by their taxonomic composition
# creates in the output directory a table for each taxonomic level
micca tabletotax -i $loc/open_ref_otus/otutable_modified.txt -t $loc/open_ref_otus/taxa_rdp_97.txt -o $loc/open_ref_otus/taxtables 
# relative abundance bar plot from generated taxa tables
mkdir $loc/open_ref_otus/taxbar
micca tablebar -i $loc/open_ref_otus/taxtables/taxtable2.txt -o $loc/open_ref_otus/taxbar/u_rab_to20_phylum_taxtable2.png  -t 20 
micca tablebar -i $loc/open_ref_otus/taxtables/taxtable3.txt -o $loc/open_ref_otus/taxbar/u_rab_to20_class_taxtable3.png  -t 20 
micca tablebar -i $loc/open_ref_otus/taxtables/taxtable4.txt -o $loc/open_ref_otus/taxbar/u_rab_to20_order_taxtable4.png  -t 20 
micca tablebar -i $loc/open_ref_otus/taxtables/taxtable5.txt -o $loc/open_ref_otus/taxbar/u_rab_to20_family_taxtable5.png  -t 20 
micca tablebar -i $loc/open_ref_otus/taxtables/taxtable6.txt -o $loc/open_ref_otus/taxbar/u_rab_to20_genus_taxtable6.png  -t 20
#--------
micca tablebar -i $loc/open_ref_otus/taxtables/taxtable2.txt -o $loc/open_ref_otus/taxbar/u_rab_to200_phylum_taxtable2.png  -t 200 
micca tablebar -i $loc/open_ref_otus/taxtables/taxtable5.txt -o $loc/open_ref_otus/taxbar/u_rab_to200_family_taxtable5.png  -t 200 
micca tablebar -i $loc/open_ref_otus/taxtables/taxtable6.txt -o $loc/open_ref_otus/taxbar/u_rab_to200_genus_taxtable6.png  -t 200
#--------

echo "------------------Building Bio Files--------------" 2>&1 | tee  >>$log_file 
mkdir -p $loc/open_ref_otus/biom
#I'm using the rdp 97 classified taxa for constructing the biom file
micca tobiom -i $loc/open_ref_otus/otutable_modified.txt -o $loc/open_ref_otus/biom/otu_table_from_rdp97_v01.biom -t $loc/open_ref_otus/taxa_rdp_97.txt -s $map_file -u $loc/open_ref_otus/otuids_modified.txt
micca tobiom -i $loc/open_ref_otus/otutable_modified.txt -o $loc/open_ref_otus/biom/otu_table_from_rdp97_v02.biom -t $loc/open_ref_otus/taxa_rdp_97.txt -s $map_file
# less stringent rdp classified
micca tobiom -i $loc/open_ref_otus/otutable_modified.txt -o $loc/open_ref_otus/biom/otu_table_from_rdp80_v01.biom -t $loc/open_ref_otus/taxa_rdp_80.txt -s $map_file -u $loc/open_ref_otus/otuids_modified.txt
micca tobiom -i $loc/open_ref_otus/otutable_modified.txt -o $loc/open_ref_otus/biom/otu_table_from_rdp80_v02.biom -t $loc/open_ref_otus/taxa_rdp_80.txt -s $map_file

# Biom to tsv
biom convert -i $loc/open_ref_otus/biom/otu_table_from_rdp97_v01.biom  -o $loc/open_ref_otus/biom/otu_table_from_rdp97_v01.tsv --to-tsv --header-key "taxonomy" --table-type "OTU table"
biom convert -i $loc/open_ref_otus/biom/otu_table_from_rdp97_v02.biom  -o $loc/open_ref_otus/biom/otu_table_from_rdp97_v02.tsv --to-tsv --header-key "taxonomy" --table-type "OTU table"
biom convert -i $loc/open_ref_otus/biom/otu_table_from_rdp80_v01.biom  -o $loc/open_ref_otus/biom/otu_table_from_rdp80_v01.tsv --to-tsv --header-key "taxonomy" --table-type "OTU table"
biom convert -i $loc/open_ref_otus/biom/otu_table_from_rdp80_v02.biom  -o $loc/open_ref_otus/biom/otu_table_from_rdp80_v02.tsv --to-tsv --header-key "taxonomy" --table-type "OTU table"
sed s'/taxonomy/Consensus Lineage/' $loc/open_ref_otus/biom/otu_table_from_rdp97_v01.tsv >$loc/open_ref_otus/biom/otu_table_from_rdp97_v01.cl.tsv
sed s'/taxonomy/Consensus Lineage/' $loc/open_ref_otus/biom/otu_table_from_rdp97_v02.tsv >$loc/open_ref_otus/biom/otu_table_from_rdp97_v02.cl.tsv
sed s'/taxonomy/Consensus Lineage/' $loc/open_ref_otus/biom/otu_table_from_rdp80_v01.tsv >$loc/open_ref_otus/biom/otu_table_from_rdp80_v01.cl.tsv
sed s'/taxonomy/Consensus Lineage/' $loc/open_ref_otus/biom/otu_table_from_rdp80_v02.tsv >$loc/open_ref_otus/biom/otu_table_from_rdp80_v02.cl.tsv

# Biom summary
biom summarize-table -i $loc/open_ref_otus/biom/otu_table_from_rdp97_v01.biom -o $loc/open_ref_otus/biom/otu_table_from_rdp97_v01.summary

echo "------------------Done--------------"  2>&1 | tee  >>$log_file
# After this I have to run the biom convert commands and make the phylsoeq obj using metadata , biom tsv and rooted tree




