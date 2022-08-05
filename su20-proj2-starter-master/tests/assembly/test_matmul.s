.import ../../src/matmul.s
# .import ../../src/utils.s
# .import ../../src/dot.s

# static values for testing
.data
m0: .word 2 5 6
m1: .word 4 7 3
d: .word 0 0 0 0 0 0# allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0,m0
    la s1,m1
    la s2,d

    # Call matrix multiply, m0 * m1
    mv a0,s1
    li a1,3
    li a2,1
    mv a3,s0
    li a4,1
    li a5,3
    mv a6,s2
    jal matmul
    
    # Print the output (use print_int_array in utils.s)
    la a0,d
    li a1,3
    li a2,3
    jal print_int_array

    # Exit the program
    jal exit