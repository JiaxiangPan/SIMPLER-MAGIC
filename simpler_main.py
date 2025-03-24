import configparser
import os
import tempfile
import SIMPLER_Mapping
import ast
import json
import sys

# usage:
# python3 simpler_main.py benchmark.blif row_size
# OR
# python3 simpler_main.py benchmark.v row_size
def main():

    config = configparser.ConfigParser()
    config.read_file(open('simpler_conf.cfg'))
    #config.read_file(open('simpler_conf_verilog.cfg'))
    input_path = sys.argv[1]
    print(os.path.basename(input_path).split('.')[0])
    input_format = config.get('input_output', 'input_format') 
    abc_dir_path = config.get('abc', 'abc_dir_path') 
    Max_num_gates = config.getint('SIMPLER_Mapping', 'Max_num_gates')
    genlib_file_path = config.get('SIMPLER_Mapping', 'genlib_file') 
    output_directory_path = config.get('SIMPLER_Mapping', 'output_directory_path')
    ROW_SIZE = int(sys.argv[2])
    generate_json = config.getboolean('SIMPLER_Mapping', 'generate_json')
    print_mapping = config.getboolean('SIMPLER_Mapping', 'print_mapping')
    print_warnings = config.getboolean('SIMPLER_Mapping', 'print_warnings')
    end_of_line_output = config.getboolean('SIMPLER_Mapping', 'end_of_line_output')
    

    abc_exe_path = os.path.join(abc_dir_path, "abc")
    abc_rc_path = os.path.join(abc_dir_path, "abc.rc")

    # Create abc script
    abc_script_file_path = config.get('abc', 'abc_script_path') ##
    abc_script = open(abc_script_file_path, 'r').read()
    abc_script = abc_script.replace('abc_rc_path', abc_rc_path)
    abc_script = abc_script.replace('input.blif', input_path)
    if input_format == 'verilog':
        abc_script = abc_script.replace('read_blif', 'read_verilog')
    abc_script = abc_script.replace('lib.genlib', genlib_file_path)#genlib
    abc_output_path = tempfile.mktemp()
    abc_script = abc_script.replace('output.v', abc_output_path)
    # with open(abc_output_path, 'r') as file:
    #     content = file.read()
    # print(content)
    # Run abc script
    abc_script_path = tempfile.mktemp()
    open(abc_script_path, "w").write(abc_script)
    os.system('%s -f "%s"' % (abc_exe_path, abc_script_path))
    # Mapping into the memory array
    SIMPLER_Mapping.SIMPLER_Main([abc_output_path], Max_num_gates, ROW_SIZE, os.path.basename(input_path).split('.')[0], generate_json, print_mapping, print_warnings, end_of_line_output, output_directory_path)
    #os.path.basename(input_path).split('.')[0]解决benchmark输入为绝对路径的时候，输出JSON文件出错的问题
    

    # Clean files
    os.remove(abc_script_path)
    os.remove(abc_output_path)

if __name__ == "__main__":
    main()
