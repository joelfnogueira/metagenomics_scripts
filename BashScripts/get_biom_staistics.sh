# CAUTION 
# Check if this script is running in qiime environment
# Check if already .tsv file is there
# Create the .tsv file with --header-key option

biom convert --to-tsv -i otu_table_mc2_w_tax.biom -o otu_table_mc2_w_tax.tsv --header-key "taxonomy" --table-type "OTU table"
biom convert --to-json -i otu_table_mc2_w_tax.biom -o otu_table_mc2_w_tax.j.biom --header-key "taxonomy" --table-type "OTU table"
biom summarize-table  -i otu_table_mc2_w_tax.biom -o otu_table_mc2_w_tax.summary
echo -n "no of OTUs :"; sed '1,2d' otu_table_mc2_w_tax.tsv | wc -l
echo -n "no of new OTUs :" ; sed '1,2d' otu_table_mc2_w_tax.tsv | cut -f1 | grep "^New" -c
echo -n "no of new OTUs Unassigned : " ; sed '1,2d' otu_table_mc2_w_tax.tsv | grep "^New" | awk -F"\t" '{print $NF}' | grep "Unassigned" -c
echo -n "no of new OTUs Assigned to Taxonomy: " ; sed '1,2d' otu_table_mc2_w_tax.tsv | grep "^New" | awk -F"\t" '{print $NF}' | grep "Unassigned" -c -v
echo -n "no of OTUs assigned to GG ids: "; sed '1,2d' otu_table_mc2_w_tax.tsv | grep "^New" -v -c

