#!/bin/sh
#
# IDR on TF and Histone Data
#
alias sbcompute4.24='sbatch --partition=bch-compute --time=24:00:00 --job-name="wtp-compute" --output=output_%j.txt --nodes=1 --ntasks=4 --mem=20G'

array=(
GSM2191196,GSM2191197,F_H3K27ac
GSM2191741,GSM2191742,F_H3K4me1
GSM2192145,GSM2192146,F_H3K4me3
GSM2191194,GSM2191195,F_H3K27me3
GSM1902461,GSM1902462,A_H3K27ac
GSM722693,GSM769025,A_H3K4me1
GSM722694,GSM769017,A_H3K4me3
GSM2461471,GSM2461472,A_H3K27me3
GSM1260026,GSM1260027,F_GATA4
GSM1260010,GSM1260011,A_GATA4
GSM3518644,GSM3518645,F_MEF2A
GSM3518665,GSM3518666,A_MEF2A
GSM3518647,GSM3518648,F_MEF2C
GSM3518650,GSM3518651,F_NKX2_5
GSM3518668,GSM3518669,A_NKX2_5
GSM3518653,GSM3518655,F_SRF
GSM2944729,GSM2944730,A_SRF
GSM3518657,GSM3518659,F_TBX5
GSM3518674,GSM3518675,A_TBX5
GSM3518661,GSM3518663,F_TEAD1
GSM3518677,GSM3518679,A_TEAD1
GSM2346444,GSM2346445,F_EP300
GSM722695,GSM918747,A_EP300
)

for i in ${array[@]}; do 
	rep1=$(echo $i | cut -d ',' -f 1) # rep1
	rep2=$(echo $i | cut -d ',' -f 2) # rep2
	name=$(echo $i | cut -d ',' -f 3) # name of file 
	sbcompute4.24 --wrap="idr --samples ${rep1}_peaks_sorted.narrowPeak ${rep2}_peaks_sorted.narrowPeak --input-file-type narrowPeak --rank p.value --output-file ${name}-idr --plot --log-output-file ${name}.idr.log"
	done


















