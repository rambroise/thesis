#!/bin/sh
#
# MAC2 peakcalling on ATAC-Seq Data
#
alias sbcompute4.24='sbatch --partition=bch-compute --time=24:00:00 --job-name="wtp-compute" --output=output_%j.txt --nodes=1 --ntasks=4 --mem=20G'

arraydata=(
GSM3579629
GSM3579630
GSM2525597
GSM2525598
)


for i in ${arraydata[@]}; do 
	sbcompute4.24 --wrap="macs2 callpeak -t ${i}_rmchrM.sorted.nodup.bam -f BAM -g 1.87e9 -n ${i} -p 1e-3 --nomodel --shift -100 --extsize 200 --call-summits --outdir macs2_peaks >macs2_peaks/${i}_macs2.log; sort -k8,8nr macs2_peaks/${i}_peaks.narrowPeak > macs2_peaks/${i}_peaks_sorted.narrowPeak"
	done