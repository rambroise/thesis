#!/bin/sh

# Bowtie2_Bam_Bigwig_rmchrM.sh type input_1.fastq.gz 
#
# type is 'ATAC' or 'CHIP'
#
# convert a fastq.gz file in the working directory to .bam, sort, remove duplicates, and make .bw file.
# If the file input_2.fastq.gz exists then the reads will be treated as paired end, otherwise single end
#
# bam file is filtered to exclude multiple alignment, low quality mapping, chrM
# 
# currently configured for E2
# 

# load modules

# alias

# constants
BOWTIE2INDEX="/reference_databases/ReferenceGenome/mm10/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome"
PATH2CHROMSIZES="/home/ch200919/annotations/mm10/mm10.chrom.sizes"
MBLACKLIST="/home/ch200919/annotations/mm10/mm10-blacklist.v2.bed"
CHIPPE_ADAPT="/home/ch200919/annotations/adapters/TruSeq3-PE-2.fa"
CHIPSE_ADAPT="/home/ch200919/annotations/adapters/TruSeq3-SE.fa"
ATAC_ADAPT="/home/ch200919/annotations/adapters/NexteraPE-PE.fa"
REMOVECHROM="/home/ch200919/scripts/removeChrom.py"

EXTEND=200 # for SE reads, amt to extend reads to make bigwig
MAX=$(nproc --all) # get the number of cores

# run flags
ALIGN="1"
SORT="1"
BW="1"

if [ $1 = "ATAC" ]; then
	type="ATAC"
elif [ $1 = 'CHIP' ]; then
	type="CHIP"
else
	echo "error: type should be either 'ATAC' or 'CHIP'"
	echo "usage: Bowtie2_Bam_Bigwig_rmchrM.sh type input_1.fastq.gz"
	exit 1
fi

infile=$2
if [ ! -f $infile ]; then
	echo "error: file not found"
	echo "usage: Bowtie2_Bam_Bigwig_rmchrM.sh type input_1.fastq.gz"
	exit 1
fi

name=${infile%_1.fastq.gz}
if [ -f ${name}_2.fastq.gz ]; then	# determine if reads are paired
	PE="1"	# paired reads
else
	PE="0"	# not paired reads
fi

	echo "====="
	echo $name  $PE
	
	if [ $ALIGN = "1" ]
	then
		echo "align"
		if [ $PE -eq 0 ]
		then
			ADAPT=$CHIPSE_ADAPT
			if [ $type = "ATAC" ]
			then
				ADAPT=$ATAC_ADAPT
			fi
			trimmomatic SE -threads $MAX ${name}_1.fastq.gz ${name}_trim_1.fastq.gz "ILLUMINACLIP:${ADAPT}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36" # trim reads and remove adapters
			bowtie2 -p $MAX -N 1 -x $BOWTIE2INDEX -U ${name}_trim_1.fastq.gz | python $REMOVECHROM - - chrM | samtools "view" -bS -q 10 - > ${name}_rmchrM.bam # align and remove chr M
		else
			[ $PE -eq 1 ]; 
			ADAPT=$CHIPPE_ADAPT
			if [ $type eq "ATAC" ]
			then
				ADAPT=$ATAC_ADAPT
			fi
			trimmomatic PE -threads $MAX ${name}_1.fastq.gz ${name}_2.fastq.gz ${name}_paired_trim_1.fastq.gz ${name}_unpaired_trim_1.fastq.gz ${name}_paired_trim_2.fastq.gz ${name}_unpaired_trim_2.fastq.gz "ILLUMINACLIP:${ADAPT}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36" # trim reads and remove adapters
			bowtie2 -p $MAX -N 1 -x $BOWTIE2INDEX -1 ${name}_paired_trim_1.fastq.gz -2 ${name}_paired_trim_2.fastq.gz | python $REMOVECHROM - - chrM | samtools "view" -bS -q 10 - > ${name}_rmchrM.bam # align and remove chr M
		fi
	fi
	if [ $SORT = "1" ]
	then
		echo "sort"
		samtools "sort" -o ${name}_rmchrM.sorted.bam ${name}_rmchrM.bam
		echo "rmdup"
		samtools rmdup -s ${name}_rmchrM.sorted.bam ${name}_rmchrM.sorted.nodup.bam
		echo "index"
		samtools index ${name}_rmchrM.sorted.nodup.bam
		rm -f ${name}_rmchrM.bam		
	fi

	if [ $BW = "1" ]
	then
		echo "bamCoverage"
    	bamCoverage -b ${name}_rmchrM.sorted.nodup.bam -o ${name}rmchrM_nodup_RPKM.bw -e $EXTEND --normalizeUsing RPKM --binSize 10 -bl $MBLACKLIST -p max
    fi

