# thesis

# This is a repository of all the scripts used in both the data-processing pipeline and analysis of this thesis. 

# In order to recapitulate the results from this thesis, a list of the SRR and GSM numbers of all desired files should first be obtained. I will outline the steps for processing the FASTQ files below using scripts from this repoositor 

# Run FastqDump
~/BatchFastqDump.sh
# this is the skeletal code for running a fastqdump. This script should be modified to contain the SRR numbers of the desired files:
# example: SRRList_BatchFastqDump.sh

# rename output files from FASTQ dump according to GSM accession codes
~/SRR2GSM.sh


# Process ChIP-Seq files
   # note that ProcessChIP.sh requires Trimmomatic_Bowtie2_Bam_Bigwig_rmchrM.sh and removeChrom.py to be uploaded to a
   # directory of scripts to remove adapters
   # as well as a file of blacklisted regions and mm10 chrom sizes

~/ProcessChIP.sh

# Process ATAC-Seq files
   # note that ProcessATAC.sh requires Trimmomatic_Bowtie2_Bam_Bigwig_rmchrM.sh and removeChrom.py to be uploaded to a
   # directory of scripts to remove adapters
   # as well as a file of blacklisted regions and mm10 chrom sizes
~/ProcessATAC.sh


# call peaks
~/peakcalling.sh


# handle replicatess with IDR
~/idr.sh  # for ChIP-Seq files
~/idr_ATAC.sh # for ATAC-Seq files
~/IDRsummit.py


# For the analyses used to make the figures, run the commands written in "CodeforFigures.txt"
