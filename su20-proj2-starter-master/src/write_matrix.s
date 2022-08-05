.globl write_matrix

.import utils.s

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix: 
    beq a0,x0,error1
    beq a1,x0,error1
    bge x0,a2,error1
    bge x0,a3,error1
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
    
    mv s0,a0
    mv s1,a1
    mv s2,a2
    mv s3,a3

    mv a1,s0
    li a2,1
    addi sp,sp,-4
    sw ra,0(sp)
    jal fopen
    lw ra,0(sp)
    addi sp,sp,4
    li t0,-1
    beq t0,a0,error53
    mv s4,a0    # file descriptor

    li a0,4
    addi sp,sp,-4
    sw ra,0(sp)
    jal malloc
    lw ra,0(sp)
    addi sp,sp,4
    beq a0,x0,error1
    mv s5,a0    # number buffer
    
    sw s2,0(s5)
    mv a1,s4
    mv a2,s5
    li a3,1
    li a4,4
    addi sp,sp,-4
    sw ra,0(sp)
    jal fwrite
    lw ra,0(sp)
    addi sp,sp,4

    sw s3,0(s5)
    mv a1,s4
    mv a2,s5
    li a3,1
    li a4,4
    addi sp,sp,-4
    sw ra,0(sp)
    jal fwrite
    lw ra,0(sp)
    addi sp,sp,4

    mv a1,s4
    mv a2,s1
    mul a3,s2,s3
    li a4,4
    addi sp,sp,-4
    sw ra,0(sp)
    jal fwrite
    lw ra,0(sp)
    addi sp,sp,4
    mul t0,s2,s3
    bne a0,t0,error54

    mv a1,s4
    addi sp,sp,-4
    sw ra,0(sp)
    jal fclose
    lw ra,0(sp)
    addi sp,sp,4
    li t0,-1
    beq t0,a0,error55

    mv a0,s5
    addi sp,sp,-4
    sw ra,0(sp)
    jal free
    lw ra,0(sp)
    addi sp,sp,4
    # Epilogue
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
error53:
    li a1,53
    jal exit2
error54:
    li a1,54
    jal exit2
error55:
    li a1,55
    jal exit2