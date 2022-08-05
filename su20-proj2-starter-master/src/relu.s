.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    bge x0,a1,error
    addi t0,x0,0    # t0为数组下标
loop_start:
    beq t0,a1,loop_end
    slli t1,t0,2
    add t1,t1,a0
    lw t2,0(t1)
    bge t2,x0,loop_continue
    addi t2,x0,0
    sw t2,0(t1)
loop_continue:
    addi t0,t0,1
    j loop_start
loop_end:
	ret
error:
    addi a0,x0,8
    ecall
