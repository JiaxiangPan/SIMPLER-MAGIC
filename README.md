# SIMPLER-MAGIC
SIMPLER MAGIC: Synthesis and In-memory MaPping of Logic Execution in a single Row for Memristor Aided loGIC

## Dependencies
In order to use SIMPLER-MAGIC, you will need a Linux machine with:
1. Python 3.6
2. [ABC Synthesis Tool](https://bitbucket.org/alanmi/abc)

## Manual
1. Configure: in the file simple_conf.cfg you will find the following content:
```ini
[input_output]
; input_format - the allowed values: verilog, blif
input_format=verilog

[abc]
; abc_dir_path - write the path to your ABC directory
abc_dir_path=/home/adi/abc/alanmi-abc-eac02745facf

[SIMPLER_Mapping]
; Max_num_gates - write the maximum number of gates the tool allows
Max_num_gates=20000
; ROW_SIZE - write all the desired row sizes (including the cells storing the inputs)
ROW_SIZE=[5,8,10,15]
; generate_json,print_mapping,print_warnings - the allowed values: True/False 
generate_json=False
print_mapping=True
print_warnings=True

```
Change the parameters according to your needs.

2. Run:
```sh
python3 simpler_main.py benchmark.blif row_size
```

# SIMPLER-MAGIC-VERSION2
Update of the Current Version (By panjiaxiang7(panjiaxiang7@163.com))
```sh
python3 simpler_main.py benchmark.blif row_size
```
The generated micro-operation files (in three formats) are located in the result directory. 
For the 5 benchmarks mentioned in the paper, corresponding micro-operations have been produced.
run.sh and ​all_run.sh are used to determine the minimum row size at which the current algorithm successfully completes the mapping.