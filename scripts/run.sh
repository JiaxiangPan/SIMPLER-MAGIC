#!/bin/bash

# 默认参数 result.csv(csv文件)
# 默认参数 benchmark(blif文件)
# 默认参数 rowsize

result_file=$1
benchmark=$2
rowsize=$3

# 检查 CSV 文件是否存在，如果不存在则创建并写入表头
if [ ! -f "$result_file" ]; then
  echo "Benchmark,Number of gates,Total number of cycles,Number of reuse cycles,Row size (number of columns)" > "$result_file"
fi

# 输出第一次命令
command="python3 simpler_main.py $benchmark $rowsize"
echo $command

# 运行第一次命令并获取结果
result=$(eval $command)

# 检查第一次结果中是否包含 "False"
if [[ $result == *"False"* ]]; then
  # 如果第一次结果包含 "False"，则 rowsize + 1
  rowsize=$((rowsize + 1))
else
  # 如果第一次结果不包含 "False"，则继续减少 rowsize 直到包含 "False"
  while [[ $result != *"False"* ]]; do
    rowsize=$((rowsize - 1))
    command="python3 simpler_main.py $benchmark $rowsize"
    echo $command
    result=$(eval $command)
  done

  # 输出上一次的 rowsize 值
  echo result $((rowsize + 1))
  command="python3 simpler_main.py $benchmark $((rowsize + 1))"
  echo $command

  # 将命令的输出按行存储到数组中
  IFS=$'\n' read -d '' -r -a result_array <<< "$(eval $command)"

  # 遍历数组并输出每一行的内容
  for line in "${result_array[@]}"; do
    echo "$line"
        # 提取信息并写入CSV文件
    if [[ $line == *"Benchmark:"* ]]; then
      benchmark=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
    elif [[ $line == *"Number of gates:"* ]]; then
      num_gates=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
    elif [[ $line == *"Total number of cycles:"* ]]; then
      num_cycles=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
    elif [[ $line == *"Number of reuse cycles:"* ]]; then
      num_reuse_cycles=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
    elif [[ $line == *"Row size (number of columns):"* ]]; then
      row_size=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')

      # 将提取的信息写入CSV文件
      echo "$benchmark,$num_gates,$num_cycles,$num_reuse_cycles,$row_size" >> "$result_file"
    fi
  done

  exit
fi

while true; do
  # 输出命令
  command="python3 simpler_main.py $benchmark $rowsize"
  echo $command

  # 运行命令并获取结果
  result=$(eval $command)

  # 检查结果中是否包含 "False"
  if [[ $result == *"False"* ]]; then
    # 如果结果包含 "False"，则 rowsize + 1
    rowsize=$((rowsize + 1))
  else
    # 如果结果不包含 "False"，输出当前 rowsize 的值并退出循环
    echo result $rowsize
    command="python3 simpler_main.py $benchmark $rowsize"
    echo $command

    # 将命令的输出按行存储到数组中
    IFS=$'\n' read -d '' -r -a result_array <<< "$(eval $command)"

    # 遍历数组并输出每一行的内容
    for line in "${result_array[@]}"; do
      echo "$line"
          # 提取信息并写入CSV文件
      if [[ $line == *"Benchmark:"* ]]; then
        benchmark=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
      elif [[ $line == *"Number of gates:"* ]]; then
        num_gates=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
      elif [[ $line == *"Total number of cycles:"* ]]; then
        num_cycles=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
      elif [[ $line == *"Number of reuse cycles:"* ]]; then
        num_reuse_cycles=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
      elif [[ $line == *"Row size (number of columns):"* ]]; then
        row_size=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')

        # 将提取的信息写入CSV文件
        echo "$benchmark,$num_gates,$num_cycles,$num_reuse_cycles,$row_size" >> "$result_file"
      fi
    done
    
    break
  fi
done
