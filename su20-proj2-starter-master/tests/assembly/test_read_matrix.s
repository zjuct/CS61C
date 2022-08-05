.import ../../src/read_matrix.s
# .import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"
row:    .word 0
column: .word 0

.text
main:
    # Read matrix into memory
    la a0,file_path
    la a1,row
    la a2,column
    jal read_matrix


    # Print out elements of matrix
    la s0,row
    lw a1,0(s0)
    la s1,column
    lw a2,0(s1)
    jal print_int_array

    # Terminate the program
    jal exit