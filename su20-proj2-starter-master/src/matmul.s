.globl matmul

.import utils.s
.import dot.s

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    

    bge x0,a1,error1
    bge x0,a2,error1
    bge x0,a4,error2
    bge x0,a5,error2
    bne a2,a4,error3
    # Error checks
    # Prologue
    addi sp,sp,-4
    sw s0,0(sp)
    addi sp,sp,-4
    sw s1,0(sp)

    mv s0,a0
    mv s1,a3
    # t0 is the row pointer of m0
    li t5,0
    li t0,0     
outer_loop_start:
    beq t0,a1,outer_loop_end
    # t1 is the column pointer of m1
    li t1,0     

inner_loop_start:
    beq t1,a5,inner_loop_end

    # push into the stack
    addi sp,sp,-4
    sw a0,0(sp)
    addi sp,sp,-4
    sw a1,0(sp)
    addi sp,sp,-4
    sw a2,0(sp)
    addi sp,sp,-4
    sw a3,0(sp)
    addi sp,sp,-4
    sw a4,0(sp)
    addi sp,sp,-4
    sw a5,0(sp)
    addi sp,sp,-4
    sw a6,0(sp)
    addi sp,sp,-4
    sw ra,0(sp)
    addi sp,sp,-4
    sw t0,0(sp)
    addi sp,sp,-4
    sw t1,0(sp)
    addi sp,sp,-4
    sw t5,0(sp)

    mv a0,s0
    mul t2,a2,t0
    slli t2,t2,2
    add a0,a0,t2

    mv a1,s1
    slli t2,t1,2
    add a1,a1,t2

    mv a2,a2
    li a3,1
    mv a4,a5
    jal ra,dot
    # t2 store the result of dot multiply
    mv t2,a0    

    

    # pop from the stack
    lw t5,0(sp)
    addi sp,sp,4
    lw t1,0(sp)
    addi sp,sp,4
    lw t0,0(sp)
    addi sp,sp,4
    lw ra,0(sp)
    addi sp,sp,4
    lw a6,0(sp)
    addi sp,sp,4
    lw a5,0(sp)
    addi sp,sp,4
    lw a4,0(sp)
    addi sp,sp,4
    lw a3,0(sp)
    addi sp,sp,4
    lw a2,0(sp)
    addi sp,sp,4
    lw a1,0(sp)
    addi sp,sp,4
    lw a0,0(sp)
    addi sp,sp,4

    slli t4,t5,2
    add t4,t4,a6

    # t4 is the position in the result matrix
    sw t2,0(t4)

    addi t1,t1,1
    addi t5,t5,1
    j inner_loop_start
inner_loop_end:
    addi t0,t0,1
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw s1,0(sp)
    addi sp,sp,4
    lw s0,0(sp)
    addi sp,sp,4
    
    ret

error1:
    li a0,2
    ecall
error2:
    li a0,3
    ecall
error3:
    li a0,4
    ecall