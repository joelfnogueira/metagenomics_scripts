# author : roshan padmanabhan
# data   : 27th June 2017
# verison : 01
# name : modify_tsv_file_v01.py
#
# Aim : this script modifies the biom tsv file created by micca pipeline by changing the OTU ids into gg OTU ids
# Micca crates a otuids.txt file 
# Using it his as tempalte to modify the biom tsv file
#
# input  :  otu_table.tsv
#  Constructed from biom file
# OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F   MPC10F    MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
# 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 Bacteria; Firmicutes; Bacilli; Lactobacillales; Enterococcaceae; Enterococcus
# 
# input  : otuids.modified.txt
# REF1    1111582
# REF2    1106254
# REF3    1105328
#
# output  : otu_table_modified.tsv 
#  Constructed from biom file
# OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F   MPC10F    MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
# 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 Bacteria; Firmicutes; Bacilli; Lactobacillales; Enterococcaceae; Enterococcus
#

if __name__ == '__main__':
    des="""
    # this script modifies the biom tsv file created by micca pipeline by changing the OTU ids into gg OTU ids
    #
    # input  :  otu_table.tsv
    #  Constructed from biom file
    # OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F   MPC10F    MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
    # 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 Bacteria; Firmicutes; Bacilli; Lactobacillales; Enterococcaceae; Enterococcus
    # 
    # input  : otuids.modified.txt
    # REF1    1111582
    # REF2    1106254
    # REF3    1105328
    #
    # output  : otu_table_modified.tsv 
    #  Constructed from biom file
    # OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F   MPC10F    MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
    # 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 Bacteria; Firmicutes; Bacilli; Lactobacillales; Enterococcaceae; Enterococcus
    """

    parser = argparse.ArgumentParser(description=des,formatter_class=argparse.RawTextHelpFormatter )
    parser.add_argument( '-i', help='micca_biom_tsv_table', action='store',dest='tsv_file',required=True)
    parser.add_argument( '-x', help='micca_otuids_modified_tsv_file', action='store',dest='otuid_file',required=True)
    parser.add_argument( '-o', help='micca_biom_tsv_modified_table', action='store',dest='out_file',required=True)

    args = parser.parse_args()
    otuidfile = args.otuid_file
    biomtsv = args.tsv_file
    outfile = args.out_file

    # otuids file into dictionary 
    with open(otuidfile ,'r') as nf:
        otuids = nf.readlines()
        otuids = [ i.replace('\n','').split('\t')  for i in otuids ]
    otuids_dict = {}
    for i in otuids:
        otuids_dict[i[0]] = i[1]

    # open the biom tsv file and replace the SampleIDs from the dict and write it to a new file
    with open(biomtsv, 'r') as tsvh:
    tsvd = tsvh.readlines()
    with open(outfile,'w') as ofh :
        for i in tsvd:
            if i.startswith("#") :
                ofh.writelines( i )
            else :
                i_list = i.split("\t")
                ggid = otuids_dict.get( i_list[0] )
                if ggid != None  :
                    i_list[0] = ggid
                    i = '\t'.join( i_list )
                    ofh.writelines( i )
