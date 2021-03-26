#!/bin/sh
#
# process ATAC files
#
alias sbcompute4.24='sbatch --partition=bch-compute --time=24:00:00 --job-name="wtp-compute" --output=output_%j.txt --nodes=1 --ntasks=4 --mem=20G'

list=(
GSM3386328
GSM3386329
GSM3386330
GSM3386331
GSM3579629
GSM3579630
GSM3847605
GSM3847606
GSM4395700
GSM4395701
GSM4395702
GSM4395703
GSM4395704
GSM4395705
GSM2982729
GSM2982733
GSM3383875
GSM3383876
GSM3383879
GSM3383880
GSM2525591
GSM2525592
GSM2525593
GSM2525594
GSM2525595
GSM2525596
GSM2525597
GSM2525598
GSM2525599
GSM2346470
GSM2346471
)

for i in ${list[@]}; do
	sbcompute4.24 --wrap="~/scripts/Trimmomatic_Bowtie2_Bam_Bigwig_rmchrM.sh 'ATAC' ${i}_1.fastq.gz"
done
	