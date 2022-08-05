.globl read_matrix

.import utils.s

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp,sp,-4
    sw s0,0(sp)
    addi sp,sp,-4
    sw s1,0(sp)
    addi sp,sp,-4
    sw s2,0(sp)
    addi sp,sp,-4
    sw s3,0(sp)
    addi sp,sp,-4
    sw s4,0(sp)
    addi sp,sp,-4
    sw s5,0(sp)
    addi sp,sp,-4
    sw s6,0(sp)

	mv s0,a0
    mv s1,a1
    mv s2,a2

    # call fopen
    mv a1,s0
    li a2,0
    addi sp,sp,-4
    sw ra,0(sp)
    jal fopen
    lw ra,0(sp)
    addi sp,sp,4
    li t0,-1
    beq a0,t0,error50
    mv s3,a0    # file descriptor
    
    # read row and column
    mv a1,s3
    mv a2,s1
    li a3,4
    addi sp,sp,-4
    sw ra,0(sp)
    jal fread
    lw ra,0(sp)
    addi sp,sp,4
    li t0,4
    bne t0,a0,error51

    mv a1,s3
    mv a2,s2
    li a3,4
    addi sp,sp,-4
    sw ra,0(sp)
    jal fread
    lw ra,0(sp)
    addi sp,sp,4
    li t0,4
    bne t0,a0,error51

    # read matrix
    lw t0,0(s1)
    lw t1,0(s2)
    mul t2,t0,t1
    slli t3,t2,2
    mv s4,t2    # s4 is the number of elements in the matrix

    mv a0,t3
    addi sp,sp,-4
    sw ra,0(sp)
    jal malloc
    lw ra,0(sp)
    addi sp,sp,4
    mv s5,a0    # the allocated address
    beq s5,x0,error1
    
    mv a1,s3
    mv a2,s5
    mv a3,s4
    slli a3,a3,2
    addi sp,sp,-4
    sw ra,0(sp)
    jal fread
    lw ra,0(sp)
    addi sp,sp,4
    slli t0,s4,2
    bne a0,t0,error51

    # call fclose
    mv a1,s3
    addi sp,sp,-4
    sw ra,0(sp)
    jal fclose
    lw ra,0(sp)
    addi sp,sp,4
    li t0,-1
    beq t0,a0,error52

    mv a0,s5
    # Epilogue
    lw s6,0(sp)
    addi sp,sp,4
    lw s5,0(sp)
    addi sp,sp,4
    lw s4,0(sp)
    addi sp,sp,4
    lw s3,0(sp)
    addi sp,sp,4
    lw s2,0(sp)
    addi sp,sp,4
    lw s1,0(sp)
    addi sp,sp,4
    lw s0,0(sp)
    addi sp,sp,4

    ret
error1:
    li a1,1
    jal exit2
error50:
    li a1,50
    jal exit2
error51:
    li a1,51
    jal exit2
error52:
    li a1,52
    jal exit2