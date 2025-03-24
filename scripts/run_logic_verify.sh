#!/bin/bash

file_1="/home/pjx/SIMPLER-MAGIC/test.bench"
file_2="/home/pjx/SIMPLER-MAGIC/test1.bench"

MAGIC_CMD=${MAGIC_PATH:-./verification}

blif_dir="/home/pjx/simpler_benchmark/blif/tableII"

MO_FILES=$(find /home/pjx/SIMPLER-MAGIC/result/tableII/ -type f -name "*.txt")

pass_count=0
failed_count=0
failed_file=""

for mo_file in $MO_FILES; do
    echo $mo_file

    filename=$(basename "$mo_file")
    name_without_extension=$(echo "$filename" | cut -f 1 -d '.')
    name_part=$(echo "$name_without_extension" | cut -f 2 -d '_')
    blif_file="$blif_dir/$name_part.blif"
    echo $blif_file

    output=$($MAGIC_CMD $mo_file $file_1 $blif_file $file_2)
    echo $output
    if [[ "$output" == *"pass"* ]]; then
        ((pass_count++))
    else
        ((failed_count++))
        failed_file="$failed_file $mo_file"
        echo "failed: $mo_file"
    fi
done

echo "pass count: $pass_count"
echo "failed count: $failed_count"
echo "failed files: $failed_file"
