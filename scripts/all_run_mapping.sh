#!/bin/bash
# Note: The input needs to be a BLIF file.
#bash all_run_mapping.sh result_file.csv
MAGIC_CMD=${ABC_PATH:-./run_mapping.sh}

result_file=$1

BLIF_FILES=$(find /home/panjiaxiang/pjx_research/simpler_benchmark/blif/verification/ -type f -name "*.blif")
for blif_file in $BLIF_FILES; do
    $MAGIC_CMD $result_file $blif_file 512
    # echo $blif_file
done

