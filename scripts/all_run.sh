#!/bin/bash
# Note: The input needs to be a BLIF file.
#bash all_run.sh result_file.csv
MAGIC_CMD=${RUN_PATH:-./run.sh}

result_file=$1

BLIF_FILES=$(find /home/pjx/SIMPLER-MAGIC/iwls93_blif/ -type f -name "*.blif")
for blif_file in $BLIF_FILES; do
    $MAGIC_CMD $1 $blif_file 25
    # echo $blif_file
done

