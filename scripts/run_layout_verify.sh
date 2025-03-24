#!/bin/bash
#对文件夹下的micro operations做验证，并且统计信息
MAGIC_CMD=${MAGIC_PATH:-./layout_legitimacy_verification}

MO_FILES=$(find /home/pjx/SIMPLER-MAGIC/result/tableV/ -type f -name "*.txt")

pass_count=0
failed_count=0
failed_file=""

for mo_file in $MO_FILES; do
    echo $mo_file
    output=$($MAGIC_CMD $mo_file /home/pjx/SIMPLER-MAGIC/log.txt)
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
