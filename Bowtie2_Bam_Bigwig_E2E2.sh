#!/bin/sh

# Bowtie2_Bam_Bigwig.sh input.fastq.bz2
#
# convert a fastq.bz2 file in the working directory to .bam, sort, remove duplicates, and make .bw file.
# bam file is filtered to include reads with high quality mapping (excludes multiple alignment)
# currently configured for E2

# load modules

# alias

# contants
BOWTIEINDEX="/reference_databases/ReferenceGenome/mm10/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome"
PATH2CHROMSIZES="/home/pu_w/annotations/mm10/mm10.chrom.sizes"
MBLACKLIST="/home/pu_w/annotations/mm10/mm10-blacklist.v2.bed"

TRIM=0	# amt to trim off 3' end -- use if 3' end has bad seq quality.
EXTEND=200 # amt to extend reads to make bigwig
MAX=$(nproc --all) # get the number of cores

# run flags

ALIGN="1"
SORT="1"
BW="1"


infile=$1

	name=${infile%.fastq.bz2}
	echo "====="
	echo $name

	if [ $ALIGN = "1" ]
	then
		echo "align"
		bunzip2 -c $infile | fastq_quality_filter -Q33 -q 25 | bowtie2 -p $MAX -N 1 -3 $TRIM -x $BOWTIEINDEX -U - | samtools "view" -bS -q 10 - > ${name}.bam
	fi

	if [ $SORT = "1" ]
	then
		echo "sort"
		samtools "sort" -o ${name}.sorted.bam ${name}.bam
		echo "rmdup"
		samtools rmdup -s ${name}.sorted.bam ${name}.sorted.nodup.bam
		echo "index"
		samtools index ${name}.sorted.nodup.bam
		rm -f ${name}.bam ${name}.sorted.bam
	fi

	if [ $BW = "1" ]
	then
		echo "bamCoverage"
    	bamCoverage -b ${name}.sorted.nodup.bam -o ${name}_RPKM.bw -e $EXTEND --normalizeUsing RPKM --binSize 10 -bl $MBLACKLIST -p max
    fi