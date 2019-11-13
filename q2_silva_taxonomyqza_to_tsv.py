# this script converts the qiime2 silva taxonomy qza file to taxonomy.tsv by splitting the taxa columns appropriately

version=0.1
author='Roshan Padmanabhan'

import re
import zipfile
import argparse
import pandas as pd

def get_tsv_from_q2taxonomy_qza_or_qzv(q2_file, tsv_file_name):
    """get data/alpha-diversity.tsv
    Returns a data frame
    """
    data = []
    try :
        with zipfile.ZipFile( q2_file ) as zip_ref:
            for i in zip_ref.filelist :
                if re.findall( tsv_file_name, i.filename ) :
                    with zip_ref.open( i.filename ) as myfile:
                        data.append(myfile.read().decode("utf-8"))
        df=pd.DataFrame( [i.split("	") for i in data[0].splitlines()[1:]]) 
        df.columns=[i.split("	") for i in data[0].splitlines()[0:1]]
        return df
    except :
        return "Problem opening artifact"

def _df2taxadf(df_taxon, df):
    res = []
    res_index = []
    res_confidence = []
    for x,y,i in list(zip( df_taxon.index, df.Confidence, df_taxon)):
        len_of_lst = len(i)
        res_index.append(x)
        res_confidence.append(y)
        if len_of_lst == 7:
            res.append([i[0], i[1], i[2], i[3], i[4], i[5], i[6]])
        elif len_of_lst == 6:
            res.append([i[0], i[1], i[2], i[3], i[4], i[5], "D_6__NA"])
        elif len_of_lst == 5:
            res.append([i[0], i[1], i[2], i[3], i[4], 'D_5__NA', 'D_6__NA'])
        elif len_of_lst == 4:
            res.append([i[0], i[1], i[2], i[3], 'D_4__NA', 'D_5__NA', 'D_6__NA'])
        elif len_of_lst == 3:
            res.append([i[0], i[1], i[2], 'D_3__NA', 'D_4__NA', 'D_5__NA', 'D_6__NA'])
        elif len_of_lst == 2:
            res.append([i[0], i[1], 'D_2_NA', 'D_3__NA', 'D_4__NA', 'D_5__NA', 'D_6__NA'])
        elif (len_of_lst == 1 and i[0] == 'Unassigned' ):
            res.append([i[0], 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned'])
        elif (len_of_lst == 1 and i[0] == 'D_0__Bacteria'):
            res.append([i[0], 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned'])
        elif (len_of_lst == 1 and i[0] == 'D_0__Eukaryota'):
            res.append([i[0], 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned', 'Unassigned'])
        else :
            res.append(i[0])
    res = pd.DataFrame(res)
    res.columns  = ["Kingdom","Phylum","Class","Order","Family","Genus","Species"]
    res["Confidence"] = res_confidence
    res.index =  res_index
    return res

def _cleanup_df( df ) :
    """Returns a clean df 
    """
    df.columns = [i[0].replace(" ", "") for i in df.columns ]
    df_taxon = df.Taxon.apply(lambda x : x.split(';'))
    df_taxon.index = df.FeatureID
    return df_taxon

def _msg():
    des="""
This script takes a qiime2 "SILVA" taxonomy qza archive and convert to taxonomy file \n
It also cleanup the taxa columns \n
"""
    return des

def _parse_args():
    parser = argparse.ArgumentParser(description=_msg(),formatter_class=argparse.RawTextHelpFormatter);
    parser.add_argument('-q', help='path to the qiime2 SILVA taxonomy qza file',action='store',dest='qza',required=True);
    parser.add_argument('-o', help='taxonomy out tsv name',action='store',dest='tsv',required=True)
    args = parser.parse_args()
    return ((args.qza, args.tsv))

def main( q2taxonomy_qza ):
    dfx = get_tsv_from_q2taxonomy_qza_or_qzv(q2taxonomy_qza, "taxonomy.tsv")
    dfy = _cleanup_df(dfx)
    dfz = _df2taxadf(dfy, dfx)
    return dfz
 
if __name__ == '__main__':
    q2taxonomy_qza, tsv_outfile = _parse_args()
    res_taxa = main(q2taxonomy_qza)
    res_taxa.to_csv(tsv_outfile, index=True, index_label=None, sep="\t")
    print("done")  


