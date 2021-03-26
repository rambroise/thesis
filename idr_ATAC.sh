#!/bin/sh
#
# IDR on TF and Histone Data
#
alias sbcompute4.24='sbatch --partition=bch-compute --time=24:00:00 --job-name="wtp-compute" --output=output_%j.txt --nodes=1 --ntasks=4 --mem=20G'

array=(
GSM3579629,GSM3579630,F_ATAC
GSM2525597,GSM2525598,A_ATAC
)

for i in ${array[@]}; do 
	rep1=$(echo $i | cut -d ',' -f 1) # rep1
	rep2=$(echo $i | cut -d ',' -f 2) # rep2
	name=$(echo $i | cut -d ',' -f 3) # name of file 
	sbcompute4.24 --wrap="idr --samples ${rep1}_peaks_sorted.narrowPeak ${rep2}_peaks_sorted.narrowPeak --input-file-type narrowPeak --rank p.value --output-file ${name}-idr --plot --log-output-file ${name}.idr.log"
	done
