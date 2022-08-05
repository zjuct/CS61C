.globl classify

.import utils.s

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    li t0,5
    bne t0,a0,error49

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

	# =====================================
    # LOAD MATRICES
    # =====================================
    
    mv s0,a0
    mv s1,a1
    mv s2,a2

    li a0,60
    addi sp,sp,-4
    sw ra,0(sp)
    jal malloc
    lw ra,0(sp)
    addi sp,sp,4
    beq a0,x0,error1
    mv s3,a0    # s3 is the address of the matrixes   [matrix row column] 

    # Load pretrained m0
    lw a0,4(s1)
    addi a1,s3,4
    addi a2,s3,8
    addi sp,sp,-4
    sw ra,0(sp)
    jal read_matrix
    lw ra,0(sp)
    addi sp,sp,4
    sw a0,0(s3)

    # Load pretrained m1
    lw a0,8(s1)
    addi a1,s3,16
    addi a2,s3,20
    addi sp,sp,-4
    sw ra,0(sp)
    jal read_matrix
    lw ra,0(sp)
    addi sp,sp,4
    sw a0,12(s3)

    # Load input matrix
    lw a0,12(s1)
    addi a1,s3,28
    addi a2,s3,32
    addi sp,sp,-4
    sw ra,0(sp)
    jal read_matrix
    lw ra,0(sp)
    addi sp,sp,4
    sw a0,24(s3)

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0,4(s3)
    lw t1,32(s3)
    sw t0,40(s3)
    sw t1,44(s3)
    mul t2,t0,t1
    slli t2,t2,2
    mv a0,t2
    addi sp,sp,-4
    sw ra,0(sp)
    jal malloc
    lw ra,0(sp)
    addi sp,sp,4
    beq a0,x0,error1
    sw a0,36(s3)

    lw a0,0(s3)
    lw a1,4(s3)
    lw a2,8(s3)
    lw a3,24(s3)
    lw a4,28(s3)
    lw a5,32(s3)
    lw a6,36(s3)
    addi sp,sp,-4
    sw ra,0(sp)
    jal matmul
    lw ra,0(sp)
    addi sp,sp,4

    lw a0,36(s3)
    lw t0,40(s3)
    lw t1,44(s3)
    mul a1,t0,t1
    addi sp,sp,-4
    sw ra,0(sp)
    jal relu
    lw ra,0(sp)
    addi sp,sp,4

    lw t0,16(s3)
    lw t1,44(s3)
    sw t0,52(s3)
    sw t1,56(s3)
    mul t2,t0,t1
    slli t2,t2,2
    mv a0,t2
    addi sp,sp,-4
    sw ra,0(sp)
    jal malloc
    lw ra,0(sp)
    addi sp,sp,4
    beq a0,x0,error1
    sw a0,48(s3)

    lw a0,12(s3)
    lw a1,16(s3)
    lw a2,20(s3)
    lw a3,36(s3)
    lw a4,40(s3)
    lw a5,44(s3)
    lw a6,48(s3)
    addi sp,sp,-4
    sw ra,0(sp)
    jal matmul
    lw ra,0(sp)
    addi sp,sp,4

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
#############################
    lw a0,48(s3)
    lw a1,52(s3)
    lw a2,56(s3)
    addi sp,sp,-4
    sw ra,0(sp)
    jal print_int_array
    lw ra,0(sp)
    addi sp,sp,4
#############################
    lw a0,16(s1)
    lw a1,48(s3)
    lw a2,52(s3)
    lw a3,56(s3)
    addi sp,sp,-4
    sw ra,0(sp)
    jal write_matrix
    lw ra,0(sp)
    addi sp,sp,4

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw a0,48(s3)
    lw t0,52(s3)
    lw t1,56(s3)
    mul t2,t0,t1
    mv a1,t2
    addi sp,sp,-4
    sw ra,0(sp)
    jal argmax
    lw ra,0(sp)
    addi sp,sp,4

    mv s4,a0    # s4 is the index of max element

    bne s2,x0,no_print

    # Print classification
    mv a1,s4
    addi sp,sp,-4
    sw ra,0(sp)
    jal print_int
    lw ra,0(sp)
    addi sp,sp,4

    # Print newline afterwards for clarity
    li a1,'\n'
    addi sp,sp,-4
    sw ra,0(sp)
    jal print_char
    lw ra,0(sp)
    addi sp,sp,4
no_print:
    mv a0,s4

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
error49:
    li a1,49
    jal exit2