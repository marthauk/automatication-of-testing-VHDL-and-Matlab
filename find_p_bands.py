#!/usr/bin/python
import fileinput

# Open txt-file containing the size n of the input n x n module
with open('matrix_size.txt','r') as input_file: 
    for val in input_file.read().split():
      matrix_size =int(val)
    print('P_BANDS will be set to "{}"'.format(matrix_size))
    input_file.close()

# Edit CONSTANT P_BANDS to be equal to the size of the n x n module
for  line in fileinput.FileInput("common_types_and_functions_new.vhd", inplace=1):
    if 'constant P_BANDS: integer :=' in line:
         print ('constant P_BANDS: integer := {};'.format(matrix_size))
    else:
      print(line)
