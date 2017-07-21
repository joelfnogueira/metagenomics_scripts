# author : roshan padmanabhan
# data   : 16th June 2017
# verison : 05

# this script modifies the biom tsv file created by micca pipeline into greengenes style format
#
# input  :  otu_table.tsv
#  Constructed from biom file
# OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F   MPC10F  MPC11F  MPC13F  MPC14F  MPC15F  MPC16F  MPC17F  MPC19F  MPC1F   MPC20F  MPC25F  MPC2F   MPC30F  MPC3F   MPC4F   MPC5F   MPC9F   MPN12F  MPN18F  MPN1F   MPN21F  MPN22F  MPN23F  MPN29F  MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
# 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 Bacteria; Firmicutes; Bacilli; Lactobacillales; Enterococcaceae; Enterococcus
# 
# output  : otu_table_modified.tsv 
#  Constructed from biom file
# OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F   MPC10F  MPC11F  MPC13F  MPC14F  MPC15F  MPC16F  MPC17F  MPC19F  MPC1F   MPC20F  MPC25F  MPC2F   MPC30F  MPC3F   MPC4F   MPC5F   MPC9F   MPN12F  MPN18F  MPN1F   MPN21F  MPN22F  MPN23F  MPN29F  MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
# 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 k__Bacteria;p__Firmicutes;c__Bacilli;o__Lactobacillales;f__Enterococcaceae;g__Enterococcus;

import argparse

def convert_x(e, each_list):
    """str,list -> str
    e -> index from enumerator
    convert the tax info into gg style format
    """
    tax_conv={0:"k__",1:"p__", 2:"c__", 3:"o__", 4:"f__", 5:"g__", 6:"s__"}
    pref = tax_conv.get(e)
    if not pref == 's__' :
        return( pref+each_list[e]+";")
    if pref == 's__' :
        return( pref+each_list[e])


def convert_x_rev(e):
    #tax_conv_rev = { 1:'s__', 2:'g__; s__', 3:'f__; g__; s__', 4:'o__; f__; g__; s__',5:'c__; o__; f__; g__; s__',6:'p__; c__; o__; f__; g__; s__' } 
    tax_conv_rev = { 1:'s__', 2:'g__; s__', 3:'f__; g__; s__', 4:'o__; f__; g__; s__',5:'c__; o__; f__; g__; s__',6:'' } 
    suf = tax_conv_rev.get(e)
    return( suf )

#----------------------------------------------------------------------

if __name__ == '__main__':
    des="""
    this script modifies the biom tsv file created by micca pipeline into greengenes style format
    # input  :  otu_table.tsv
    #  Constructed from biom file
    # OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F  MPN23F  MPN29F  MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
    # 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 Bacteria; Firmicutes; Bacilli; Lactobacillales; Enterococcaceae; Enterococcus
     
    # output  : otu_table_modified.tsv 
    #  Constructed from biom file
    # OTU ID    MPA26F  MPA27F  MPA28F  MPA6F   MPA7F   MPA8F  MPN23F  MPN29F  MPN2F   MPN3F   MPN4F   MPN5F   MPN6F   MPN7F   MPN8F   taxonomy
    # 1111582   0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 k__Bacteria;p__Firmicutes;c__Bacilli;o__Lactobacillales;f__Enterococcaceae;g__Enterococcus;
 
    """
    parser = argparse.ArgumentParser(description=des,formatter_class=argparse.RawTextHelpFormatter )
    parser.add_argument('-i', help='micca_otu_table.tsv', action='store',dest='tsv_file',required=True)
    parser.add_argument('-o', help='micca_out_table_modified.tsv', action='store',dest='out_file',required=True)

    args = parser.parse_args()
    infile = args.tsv_file
    outfile = args.out_file
    
    #infile="otu_table.tsv"
    #outfile='otu_table_modified.tsv'
    
    with open(infile, 'r') as ifh:
        data = ifh.readlines()

    first_two = data[0:2]
    # print the first two lines
    with open(outfile,'w') as ofh :
        for i in first_two:
            ofh.writelines(i)
        
        # modify the rest of tax info
        for i in data[2:]:
            i = i.split("\t")
            obs = '\t'.join(i[:-1])
            tax = i[-1].replace('\n','').split("; ")
            obsv_dat = obs+"\t"
            ofh.writelines(obsv_dat)
            tax_n =[]
            #print( 'Original : \t' + str( len(tax) ) + "\t" + ' '.join( tax ))

            # for unclassified
            if len( tax) == 1 and tax[0] == 'Unclassified':
                #print( str( len(tax) ) + "\t" + ' '.join( tax ))
                tax_n.append( 'Unassigned' )

            # for the taxa upto sp discription is availoable
            elif len(tax) == 7:
                _x = ' '.join( [ convert_x( e, tax ) for e,i in enumerate(tax ) ] )
                tax_n.append( _x )
            # 
            else :
                _diff =  7-len(tax)
                _x = ' '.join( [ convert_x(e, tax)  for e,i in enumerate( tax ) ])
                _x = _x +' ' +convert_x_rev(_diff)
                tax_n.append( _x )
            tax_gg =' '.join(tax_n)
            ofh.writelines(tax_gg+"\n")

#--------------------------------------------------------------------

