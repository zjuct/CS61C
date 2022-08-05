.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    addi sp,sp,-4
    sw s0,0(sp)
    addi sp,sp,-4
    sw s1,0(sp)
    # Prologue
    bge x0,a2,error1
    bge x0,a3,error2
    bge x0,a4,error2
    addi t0,x0,0    # t0为向量下标
    addi t1,x0,0    # t1为点积
loop_start:
    beq t0,a2,loop_end
    slli t2,t0,2
    mul t3,t2,a3    
    add t3,t3,a0
    mul t4,t2,a4
    add t4,t4,a1
    lw s0,0(t3)
    lw s1,0(t4)
    mul t2,s0,s1
    add t1,t1,t2
    addi t0,t0,1
    j loop_start
loop_end:
    add a0,t1,x0

    # Epilogue
    lw s1,0(sp)
    addi sp,sp,4
    lw s0,0(sp)
    addi sp,sp,4
    ret
error1:
    addi a0,x0,5
    ecall
error2:
    addi a0,x0,6
    ecall