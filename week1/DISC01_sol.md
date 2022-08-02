# DiSC 01 sol

# 1 Pre-Check

## 1.1

True. It depends on how we interpret those bits.

## 1.2

False. The range of Two's complement of n bits is $[-2^{n-1}, 2^{n-1}-1]$, so the addition of two oppsite numbers can’t be out of range.

## 1.3

False. Negetive number's first digit is 1.

## 1.4

True. Because there exists negative number only if bias is a negative number.

# 2 Unsigned Integers

## 2.1

### a

128+19=147 0x93<br>
0b111111 0x3F<br>
36   0x24<br>
0b0  0x0<br>
0b110110101  0x1B5<br>
0b100100011   291

### b

0b1101001110101101<br>
0b1011001100111111<br>
0b0111111011000100

### c

64KB 128MB 8TB 64GB<br>
8GB 2EB 128TB 512PB

### d

2^11   2^19   2^24<br>
2^58   2^36   2^67

# 3 Signed Integers

## 3.1

### a

255,0<br>
128,-127<br>
127,-128

### b

0b00000000    0b00000001   can't<br>
0b01111111   0b10000000    0b01111110<br>
0b00000000    0b00000001    0b11111111

### c

0b00010001   can't<br>
0b10010000  0b01101110<br>
0b00010001    0b11101111

### d

Not exist 

### e

Without loss of generality, assuming that x is 0 or positive. Suppose that the two's complement representation of x is $a_{n-1}a_{n-2}…a_{0}$, in which $a_{i}$ is either 0 or 1, and $a_{n-1}$ is 1. Because $\hat{a}$ is flipping all the bits of 1, which means $\hat{a}_{i} == 1$if and only if $a_{i}==0$, $\hat{a}_{i}==0$ if and only if $a_{i} == 1$. So $x+\hat{x}$ is all 1 in bits. Then adding 1 to it causes overflow, resulting in all 0, which indicates that $x+\hat{x}+1 == 0$,  proving the validity of the inversion trick.

### f

radix 2 : Prefered in logic curcits, because it is easy to represent 0 and 1 in volts.<br>
radix 10: daily life.<br>
radix 16: represent radix 2 in the way that is easy to approach by human.

# 4 Arithmetic and Counting 

## 4.1

### a

0b010010    18<br>
0b011101    29<br>
***0x01   1     一共只有6bit   会overflow***<br>
***0xFF not exists***

### b

9<br>
6<br>
7<br>
我觉得是41