#!/bin/sh

# batchFastqDump.sh DIR
# Will batch download the SRR files in the batch list to the directory DIR.
# Need to edit the batch list to customize
# Call with biogrids activated in the environment
#
alias sbcompute4.4='sbatch --partition=bch-compute --time=04:00:00 --job-name="wtp-compute" --output=output_%j.txt --nodes=1 --ntasks=4 --mem=20G'

if [ -z $1 ] || [ ! -d $1 ]; then		# make sure DIR is an established directory
	echo "No target directory specified or it does not exist"
	exit 1
fi

list=(
SRR6503172
SRR6503173
SRR6503174
)

for i in ${list[@]}; do
	sbcompute4.4 --wrap="fastq-dump --origfmt --gzip --outdir $1 $i"
done
