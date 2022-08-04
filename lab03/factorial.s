.globl factorial

.data
n: .word 6

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit
# 参数在a0,返回值在a0
factorial:
    addi t1,x0,1
loop:
    bge x0,a0,exit
    mul t1,t1,a0
    addi a0,a0,-1
    j loop
exit:
    addi a0,t1,0
    jr ra