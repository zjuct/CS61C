.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    bge x0,a1,error
    addi t0,x0,0    # t0为数组下标
    addi t1,x0,0    # t1为最大值下标
    lw t2,0(a0)     # t2为最大值
loop_start:
    beq t0,a1,loop_end
    slli t3,t0,2
    add t3,t3,a0
    lw t4,0(t3)
    bge t2,t4,loop_continue
    add t2,t4,x0
    add t1,t0,x0
loop_continue:
    addi t0,t0,1
    j loop_start
loop_end:
    add a0,t1,x0
    ret
error:
    addi a0,x0,7
    ecall