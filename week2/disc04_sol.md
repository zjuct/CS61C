# DISC 04 sol

## Pre-Check<br>
### 1.1<br>
False. **a** registers can be change, which is used to store function arguments and return values. **s** registers together with ra can't be changed.

### 1.2<br>
~~False. If the size of the array is only 1, in which case x[1] does not exist.~~

False. This only holds for data types that are four bytes wide, like int or float.

### 1.3<br>
True. Can use lw a1, 0(a0); jalr ar, 0(a1)

True. If the compiler/OS allows it, it is possible for your code to jump to and execute instructions passed into the program via an array.

### 1.4<br>
True. Because the ASCII code of 'd' is 100

### 1.5<br>
False. jalr dst, res, imm  specify the register to store PC + 4, which is register dst.

### 1.6<br>
False. j label is the alias of jal x0, label, which doesn't save the address of the next instruction.

## 2 RISC-V: A Rundown<br>
### 2.1<br>
```
addi    s0, x0, 5   # s0 = 5
sw      s0, 0(s1)   # s1[0] = s0
mul     t0, s0, s0  # t0 = the lower 32 bits of s0*s0
sw      t0, 4(s1)   # s1[4] = t0
```

## 3 Registers<br>
### 3.1<br>
```
add x8, x0, x11
or  s2, ra, t5
```

## 4 Basic Instructions<br>
### 4.1<br>
a) t0 = 4<br>
b) arr = {1,2,3,4,4,6,0}<br>
c) t1 = 16; t2 = s0 + 16; t3 = 4; t3 = 5; arr = {1,2,3,4,5,6,0}<br>
d) t0 = 1; t0 = 0xFFFFFFFE; t0 = 0xFFFFFFFF

## 5 C to RISC-V<br>
### 5.1<br>
```
# a
addi s0, x0, 4
addi s1, x0, 5
addi s2, x0, 6
add  s3, s0, s1
add  s3, s3, s2
addi s3, s3, 10

# b
sw  x0, 0(s0)
addi s1, x0, 2
sw  s1, 4(s0)
slli t0,s1,2
add t0,t0,s0
sw s1,0(t0)

# c
    addi s0, x0, 5
    addi s1, x0, 10
    add t0, s0, s0
    beq t0, s1, Eq
    addi s1, s0, -1
    j exit
Eq: addi s0, x0, 0
exit:

# d
int a = 0;
int b = 1;
int c = 30;
while(a != c){
    b = b + b;
    a++;
}

# e
addi s1, x0, 0
loop:
    bge x0, s0, exit
    add s1, s1, s0
    addi s0,s0,-1
    j loop
exit:
```

## 6 RISC-V with Arrays and Lists<br>
### 6.1<br>
t0 = 3<br>
t1 = 4<br>
t2 = t0 + t1 = 7<br>
arr[1] = 7

### 6.2<br>
Add 1 to the value of every node in the list

### 6.3<br>
Negates the first 6 element in array.

## 7 RISC-V Calling Conventions<br>
### 7.1<br>
Put the arguments in registers a0-a7

### 7.2<br>
Put the return values in registers a0-a1

### 7.3<br>
SP is a register, which points to the bottom of the stack. addi SP by 4 and store register. load register and subtract SP by 4.

### 7.4<br>
Volatile registers that caller may use after calling function. a0-a7,t0-t6,ar.

### 7.5<br>
Saved registers that callee may use in the function. s0-s11,sp

### 7.6<br>
s0-s11,sp<br>
a0-a7,t0-t6,ar

## 8 Writing RISC-V Functions<br>
### 8.1<br>
a0,a1

### 8.2<br>
```
# Arguments: a0 = n
# Return value: a1 is the result
sumSquare:
    addi t0,x0,0    # t0 is the sum
loop:   
    bge x0, a0, exit
    # Assume that square take arguments a0 and the return value is in a2
    addi sp,sp,-4
    sw ar,0(sp)
    jal square
    lw ar,0(sp)
    addi sp,sp,4
    add t0,t0,a2
    addi a0,a0,-1
    j loop
exit:
    addi a1, t0, 0
    jr ar
```

## 9 More Translating between C and RISC-V<br>
### 9.1<br>
Calculate $x^{y}$
```
int result = 1;
while(y != 0){
    result *= x;
    y--;
}
x = result
```
