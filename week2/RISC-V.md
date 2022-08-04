# RISC-V（32位系统）

## Register

> 寄存器属于体系结构中的Datapath

- 32位RISC-V的寄存器为32-bits（一个word），寄存器一共32个，按照x0到x31编号
- 寄存器可以通过编号(x4)访问，或者通过名称访问

寄存器编号和名称有以下**对应关系**

|编号|名称|用途|
|:--- | :---|:---|
|s0-s1|x8-x9|存放程序变量|
|s2-s11|x18-x27|存放程序变量|
|t0-t2|x5-x7|存放临时变量|
|t3-t6|x28-x31|存放临时变量|

### 特殊寄存器

- Zero Register

x0为零寄存器，其值永远为0，所有试图改变x0值的指令都将无效

零寄存器可以通过编号**x0**或者名称**zero**来访问

用途

1. 获取零值
2. 当作垃圾桶来使用，因为改变其值的指令无效

## 汇编指令

汇编代码中，注释以#开始

### Arithmetic Instructions（算数指令）

所有的RISC-V汇编算数指令都遵照如下格式

> op dst, src1, src2

#### add

> add dst, src1, src2

功能: R[ds1t] = R[src1] + R[src2]

#### sub 

> sub dst, src1, src2

功能：R[ds1t] = R[src1] - R[src2]

#### mul & mulh

> mul dst, src1, src2<br>
> mulh dst, src1, src2

mul将R[src1]和R[src2]的乘积的低32位存入dst中；mulh将R[src1]和R[src2]的乘积的高32位存入dst中

#### div & rem

> div dst, src1, src2<br>
> rem dst, src1, src2

mul将R[src1]和R[src2]相除的商存入dst中；mulh将R[src1]和R[src2]相除的余数存入dst中

#### 位运算

|指令|汇编码|
|:---|:---|
|And|and s1,s2,s3|
|And imm| andi s1,s2,imm|
|Or|or s1,s2,s3|
|Or imm| ori s1,s2,imm|
|Exclusive Or| xor s1,s2,s3|
|Exclusive Or imm| xori S1,s2,imm|


---

### Immediate Instructions（立即数指令）

所有的RISC-V汇编立即数指令都遵照如下格式

> opi dst, src, imm

- 立即数指令以i结尾，用立即数替换第二个src寄存器
- 立即数最多为12-bits
- 立即数被当作符号扩展后的2's complement处理

#### addi

> addi dst, src, imm

功能: R[dst] = R[src] + imm

---

### Data Transfer Instructions（数据转移指令）

Data transfer instructions move data between registers and memory
- Store: register TO memory
- Load: register FROM memory

数据转移指令格式如下

> memop reg, off(bAddr)

- memop = opertion name
- reg = register for opertion source or destination
- bAddr = register with pointer to memory(base address)
- off = address offset(immediate) in bytes

从内存地址 **bAddr+off** 处存取数据

#### lw 

> lw reg, off(bAddr)

功能：R[reg] = M[off + R[bAddr]]

#### sw

> sw reg, off(bAddr)

功能：M[off + R[bAddr]] = R[reg]

- RISC-V内存**按byte寻址**，也就是说两个相邻的word之间相差4个字节，lw和sw都是针对一个word的操作，RISC-V采用**little-endian**，一个word中相对不重要的（低位）字节存放在内存单元的低地址处
- 由于内存按byte寻址，因此offset也要以byte为单位，比如假设寄存器s3中存放int类型数组的首地址，那么将数组第二个元素加载到t0中的指令即为
```RISC-V
lw  t0, 4(s3)
```

**Big Endian VS Little Endian**<br>
```
big endian      0(s0)       1(s0)       2(s0)       3(s0)
word的高位(msb)   00          00          01          80     word的低位(lsb)
                3(s0)       2(s0)       1(s0)       0(s0)    little endian    
```
Big Endian将word的低位字节（最右边的字节）存放在内存的高地址，即按内存地址由低到高从左往右存放；Little Endian将word的低位字节存放在内存的低地址，即按内存地址由低到高从右往左存放

---

### Byte Instructions

lb和sb指令针对一个byte进行操作，将指定寄存器的最低位byte保存到内存中，或从内存中加载一个byte的数据经符号扩展博保存到寄存器中

> lb reg, off(bAddr)<br>
> sb reg, off(bAddr)

- 对于sb，寄存器的高位字节将被忽略，被保存的只有最低的字节
- 对于lb，会对内存中的byte进行sign-extrnsion，再加载到寄存器中

例：假设s0指向的内存处存放word为0x00000180
```
lb s1, 1(s0)    # s1 = 0x00000001
lb s2, 0(s0)    # s2 = 0xFFFFFF80  注意sign-extension
sb s2, 2(s0)    # *s0 = 0x00800180
```

### Half-Word Instructions

lh和sh指令针对两个byte进行操作，将指定寄存器的最低两byte保存到内存中，或从内存中加载两个byte的数据经符号扩展保存到寄存器中

> lh reg, off(bAddr)<br>
> sh reg, off(bAddr)

### Unsigned Instruction

lhu/lbu与lh/lb的唯一区别在于，原先的sign-extension变为zero-extension

> lhu reg, off(bAddr)<br>
> lbu reg, off(bAddr)

---

### Control Flow Instructions

几类Branch指令<br>
**Branch If Equal**(相等即跳转)<br>
如果R[reg1] == R[reg2]，则PC = label<br>
> beq reg1, reg2, label

**Branch If Not Equal**(不等即跳转)<br>
> bne reg1, reg2, label

**Branch Less Than**(小于即跳转)<br>
如果R[reg1] < R[reg2]，则PC = label<br>
> blt reg1, reg2, label

**Branch Greater Than or Equal**(大于等于即跳转)<br>
> bge reg1, reg2, label

**无条件跳转**<br>
> j label

### Shifting Instructions

- Logical shift: 多出来的位补零
- Arithmetic shift: 多出来的位补符号位（只存在于右移）

|指令|汇编码|
|:---|:---|
|Shift Left Logical|sll s1,s2,s3|
|Shift Left Logical imm| slli s1,s2,imm|
|Shift Right Logical|srl s1,s2,s3|
|Shift Right Logical imm| srli s1,s2,imm|
|Shift Right Arithmetic| sra s1,s2,s3|
|Shift Right Arithmetic imm| srai S1,s2,imm|

移位指令的寄存器版本以s3中的值作为位移的位数，立即数版本以立即数作为位移的位数

- 立即数版本的立即数必须为0-31
- 寄存器版本的s3只有最低5位有效（代表一个unsigned值）

```
例：使用位移指令实现 lbu s1, 1(s0)
lw      s1,0(s0)
li      t0,0x0000FF00
and     s1,s1,t0
srli    s1,s1,8
```

### Compare Instructions

Set Less Than<br>
> slt dst, reg1, reg2

如果R[reg1] < R[reg2]，则dst=1，否则dst=0

Set Less Than Imm<br>
> slti dst, reg1, imm

如果R[reg1] < imm，则dst=1，否则dst=0

### Environment Call

ecall指令调用操作系统命令

寄存器a0中的值将被操作系统使用<br>
- 屏幕打印
- 退出程序
- 分配内存

---

### 伪指令

第一种伪指令不会翻译成机器语言

```
.data           #.data表示数据段的开始
source:         #使用一个自定义的label来标记数据段
    .word 3     #.word .byte 等都是在内存中存放数据的伪指令
    .word 1
    .word 4
.text
main:           #.main表示代码段的开始
    la t1, source
    lw t2, 0(t1)
    lw t3, 4(t1)
```

第二种伪指令是普通指令的特例（别名）

**mv**<br>
> mv dst, reg1<br>

R[dst] = R[reg1]<br>
被翻译为addi dst, reg1, 0

**li**(Load Immediate)<br>
> li dst, imm

R[dst] = imm<br>

**la**(Load Address)<br>
> la dst, label

将label代表的地址放入dst

**nop**(No Operation)<br>
> nop

什么也不做<br>
被翻译为addi x0,x0,0

---

## RISC-V函数调用

1. **Put arguments** in a place where the function can access them.
2. Transfer control to the function.
3. The function will acquire any(local) storage resources it needs.
4. The function preforms its desired task.
5. The function puts return value in an accessible place and "clean up".
6. Control is return to the caller.

下面是一些约定俗称的寄存器使用规定

用来放置**函数参数和返回值**的寄存器

- a0-a7用来放置函数参数
- a0-a1用来放置返回值

**栈的使用**<br>
sp(stack pointer): 始终指向栈顶，下一个要被弹出的元素的位置

```
# 压栈(注意一个word需要4 bytes)
addi    sp,sp,-4
sw      s0,0(sp)
# 弹栈
lw      s0,0(sp)
addi    sp,sp,4
```

**函数调用/返回指令**<br>

**jal**(Jump and Link)<br>
jal用于函数调用，其先将函数调用的下一条指令地址(PC+4)存入寄存器dst，然后跳转到label

> jal dst label

```
R[dst] = PC + 4
PC = PC + offset
```

**jalr**(Jump and Link Register)<br>
jalr同样用于函数调用，只不过其寻址方式为基址偏移寻址

> jalr dst, src, imm

```
R[dst] = PC + 4
PC = R[src] + imm
```

**jr**(Jump Register)<br>
jr用来从函数返回，将寄存器中的地址装入PC

> jr src

```
PC = R[src]
```

- jr为伪指令，其被翻译为 jalr x0, src, 0
- 一般使用ra(Return Address)寄存器来保存返回地址
- j也为伪指令，被翻译为 jal x0, label

**Saved Registers VS Volatile Registers**<br>
RISC-V将几乎所有的寄存器分成两类（除极个别特殊寄存器外），一类为Saved Registers，函数调用时由被调用者负责维持不变，另一类为Volatile Registers，函数调用时由调用者负责维持不变

**Saved Registers**<br>
- 函数调用不应该改变Saved Registers的值
- 这要求如果callee改变了这些寄存器的值，需要提前通过压栈等方式保存

Saved Registers包括**s0-s11以及sp**

**Volatile Registers**<br>
- Volatile Registers由callee自由使用，如果caller需要这些值的话，应在函数调用之前保存

Volatile Registers包括t0-t6,a0-a7，以及ra

## RISC-V 指令结构

RISC-V采用定长指令集，所有指令的长度都为1 word = 4 bytes

### R-format<br>
R-Format适用于参数为三个寄存器的指令，如add,xor,mul等算数逻辑指令
<img src=img/R-format.png>

- 每个field都各自当作unsigned int处理
- R-format的opcode都为0110011
- 5位的rd为结果寄存器
- 5位的rs1和rs2为两个操作数寄存器
- 3位的funct3和7位的funct7用作同一format内不同指令的区分，如add的funct3为000，funct7为000000

<img src=img/R-format2.png>

### I-format<br>
I-format适用于addi,lw,jalr,slli等与立即数相关的指令以及load类指令
<img src=img/I-format.png>

- I-format与R-format的唯一不同在于，R-format的5位rs2和7位funct7被合并为12位的imm，用来表示立即数
- I-format只能表示12位的signed立即数，立即数会被sign-extension为32位，也就是说立即数范围为$[-2^{11},2_{11}-1]$

所有的I-format算数逻辑指令如下
<img src=img/I-format2.png>

- 根据funct3来区别同一format中的不同指令
- 由于funct3只能表示8种不同的指令，因此SRLI和SRAL使用原先funct7中的某一位来区分，因为shift-by-immediate指令只是用立即数的低5位

所有Load类指令都为I-format
<img src=img/I-format3.png>

- 3位的width用来区别指令为load byte/half-word/word，以及是signed还是unsigned
- 12位的offset就是正常的byte单位
<img src=img/I-format4.png>

### S-format<br>
S-format适用于sw,sb等store类指令
<img src=img/S-format.png>

- 5位的rs1为存放基地址的寄存器
- 5位的rs2为存放数据的寄存器
- 由于Store类指令不需要往寄存器中写入数据，因此没有rd，因此将原先的5位rd和最后的7位组合起来构成12位的imm，实际操作就是直接把两段拼接起来
- imm同样是正常的byte单位
<img src=img/S-format2.png>

### SB-format<br>
SB-format适用于beq,bne等branch类指令

Branch类指令使用PC相对寻址，RISC-V中的PC指向**当前正在执行**的指令（与LC-3不同），Branch类指令实际编码的是label相对PC的offset

- 由于当前使用的ISA中所有的指令都占一个word，因此可以使用word单位的offset来防止跳转到非法位置，同时增加跳转范围，但RISC-V实际使用的为half-word单位的offset，这是为了兼容16位的ISA
- 因此，虽然立即数只有12位，但Branch类指令的跳转范围为$[-2^{12},2^{12}-2]$bytes，以2bytes为间隔

<img src=img/S-format.png>

立即数编码方式<br>
- 首先将offset按byte单位表示，即13位立即数
- 由于byte单位的offset一定是2的倍数，因此立即数的第0位一定为0，不需要编码
- 其余各位按照上图所示编码，将第11位提前的原因是为了最低限度地改变S-format

```
Loop:   beq x19,x10,End
        nop
        nop
        j   Loop
End:    nop
```
上面的beq x19,x10,End编码为
```
0 000000 01010 10011 000 1000 0 1100011
```

<img src=img/S-format2.png>

### U-format<br>
U-format适用于lui,auipc等与高位立即数(upper immediates)相关的指令

> 高位立即数指的是长度为20-bits的立即数

U-format指令为了解决32位立即数问题，由于普通的立即数指令只能表示12位立即数，因此需要U-format的20位立即数表示高位来共同表示32位立即数

<img src=img/U-format.png>

- U-format一般与普通的立即数指令配合使用，因此表示立即数的31:12位
- 只有两个指令为U-format
  - LUI -- Load Upper Immediate
  - AUIPC -- Add Upper Immediate to PC

**LUI**<br>
> lui des, imm

- LUI用来设置寄存器的高位，其将20位立即数写入目的寄存器的高20位，并将低12位置零
- LUI常与addi配合使用，将32位立即数写入目的寄存器

```
# 例1：将x10置为0x87654321
lui x10, 0x87654
addi x10, x10, 0x321

# 例2：将x10置为0xDEADBEEF
# 错误做法
lui x10, 0xDEADB
addi x10, x10, 0xEEF
# 上面这么做是有问题的，addi的立即数需要经过sign-extension，而12位的0xEEF实际上为负数，因此x10的最终结果为0xDEADAEEF
# 正确做法
lui x10, 0xDEADC    # 预先将高位加1
addi x10, x10, 0xEEF
```
实际上，伪指令li可以自动解决上面的情况，因此推荐直接使用li

**AUIPC**<br>
> AUIPC des, imm

AUIPC用于PC相对寻址，imm扩展为高20位（低位填充0）后与PC相加，结果存入des中

```
auipc x10,0     # 获取当前的PC值
```

### UJ-format<br>
UJ-format适用于jal等jump类指令

使用I-format的branch类指令只能实现小范围跳转，而使用UJ-format的jump类指令可以实现大范围跳转

jal的指令格式如下

<img src=img/jal.png>

- 高20位的imm实际上表示的是21位byte单位offset的20:1位（因为第0位一定为0）
- 实际能跳转的范围为正负$2^{20}$ bytes

jalr的指令格式如下

> jalr不是UJ-format，而是I-format

<img src=img/jalr.png>

- 其offset不需要乘2，直接加上base寄存器中的值作为PC的值

jalr的使用
```
# 两个由jalr延伸出的伪指令(ret 和 jr)
ret = jr ra = jalr x0, ra, 0
jalr x1 = jalr ra, x1, 0    # 省略版的jalr
# 调用32-bits地址处的函数
lui x1, <high 20 bits>  # 先利用lui将高20位地址存入寄存器
jalr ra, x1, <low 12 bits>  # 要注意jalr对12位offset的sign-extension
# 实现32位offset的PC相对寻址
auipc x1, <high 20 bits>
jalr x0, x1, <low 12 bits>
```





