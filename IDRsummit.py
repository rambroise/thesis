from __future__ import division
from __future__ import print_function
__author__ = 'williampu'


# IDRsummit.py file distance > outfile.txt
# read in IDR output file in narrowPeak format
# for each consensus peak from IDR, select the stronger replicate peak.
# output its peak summit plus/minus distance. Include a peak name as chr_start_end and strength

import math
import re
import sys

def main(argv):
    infile=argv[0]
    dist=int(argv[1])

    f=open(infile,'r')
    chr=0
    start=1
    end=2
    name=3
    score=4
    strand=5
    signal=6
    pval=7
    qval=8
    summit=9
    localidr=10
    globalidr=11
    r1_start=12
    r1_end=13
    r1_signal=14
    r1_summit=15
    r2_start=16
    r2_end=17
    r2_signal=18
    r2_summit=19

    for l in f:
        e=l.strip().split("\t")
        if float(e[r1_signal]) > float(e[r2_signal]):
            pos=12
        else:
            pos=16
        summit=int(e[pos])+int(e[pos+3])
        st=summit-dist
        if st<0:
            st=0
        en=summit+dist+1

        print (e[chr] + "\t" + str(st) + "\t" + str(en) + "\t" + e[chr]+"_"+str(st)+"_"+str(en) + "\t" + "1000" + "\t" + e[strand] + "\t" + e[pos+2] + "\t" + e[pval] + "\t" + e[qval] + "\t" + str(dist) )
        
    f.close()


if __name__ == "__main__":
    main(sys.argv[1:])