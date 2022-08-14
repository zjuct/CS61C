# RISC-V CPU

CPU组成<br>
- Datapath: Contains the hardware necessary to **perform operations** required by the processor.
- Control: **Decides** what each piece of the datapath should do.

# 单时钟周期RISC-V CPU Datapath设计

下面搭建单时钟周期RISC-V CPU，使之能够执行所有类型的RISC-V指令

## R-Type

What needs to be done before R-type instructions are executed or evaluated?

- Get the instruction
- Parse instruction fields(rd, rs1, rs2, operation...)
- Read data based on parsed operands
- Perform operation
- Write result to destination register

下面的CPU可以实现R-Type指令的执行

<img src=img\1.png>

1. 获取指令: PC寄存器保存当前指令地址，将其输入内存，获取指令
2. 解析指令，将指令分成不同的段，获取rd, rs1, rs2等
3. 将rd, rs1, rs2等输入Register file，输出为寄存器的值
4. rs1和rs2寄存器的值作为操作数输入ALU，输出写回Register file
5. Control发出ALUSel信号，选择ALU进行哪种运算
6. PC自增4，指向下一条指令

ALUSel由func3和func7映射而来，多个func3，func7可能映射为同一个ALUSel信号

**Reigster File内部介绍**

<img src=img\Register-File.png>

- Register File 包含31个寄存器，portW为向寄存器中写入的数据，portA和portB为寄存器输出的值
- 指定RA和RB后，RA中的数据会从portA输出，RB中的数据会从portB中输出
- Write Enable信号控制Register File是否可写，Write Enable为1时，portW的值会被写入由RW指定的寄存器
- CLK为时钟信号

## Arithmetic I-Type

算数类型的I-Type指令与R-Type的唯一区别在于运算数2由寄存器变为立即数，因此只要加一个处理立即数的模块，同时在ALU的输入2上加一个Mux进行选择即可

<img src=img\2.png>

- Imm.Gen模块对指令的31:20位进行sign-extension
- Control通过BSel信号来控制ALU的输入B
- ImmSel控制如何对立即数进行处理

## Load I-Type

Load I-Type与Arithmetic I-Type的区别在于，Load I-Type通过ALU得到的输出会被用于内存寻址，然后内存中对应的值会被写回寄存器

<img src=img\3.png>

- MemRW信号就是内存的Write Enable信号
- WBSel信号控制写入寄存器的是ALU直接计算出来的值还是从内存中输出的值

**Memory内部介绍**

<img src=img\Memory.png>

- 一个输入端口，Data In，用于将数据写入内存
- 一个输出端口，Data Out，用于获取内存的值
- 地址端口Address指定内存地址
- Write Enable信号控制内存是写入还是读取，Write Enable=0时，从内存中读取数据，Address指定的内存地址的内容会从Data Out输出; Write Enable=1时，向内存中写入数据，Data In端口的输入会被写入Address指定的内存地址
- CLK时钟信号只在向内存中写入数据时发挥作用

## S-Type

S-Type向内存中写入数据，即MemRW=1

<img src=img\4.png>

- Register File中portB的输出被送往内存的DataW端口
- RegWEn信号控制寄存器是否可以写入，S-Type指令不往寄存器中写入数据，故RegWEn=0

## SB-Type

SB-Type要求支持比较，同时要能够将数据写入PC

<img src=img\5.png>

- ALU的运算数1前增加一个Mux，SB-Type指令要求PC与imm相加，因此ALU的运算数1选择与PC相连，运算数2与imm相连
- ASel信号控制ALU的操作数1为PC还是PortA
- PCSel信号控制PC下一轮的值是PC+4还是ALU输出的值，PCSel信号由比较器产生的信号决定

**比较器内部介绍**

<img src=img\Comp.png>

- 两个输入端口，对应两个比较数
- 两个输出端口，A = B时，BrEq=1；A < B时，BrLT=1
- BrUn信号决定比较方式为有符号还是无符号，BrUn=1为无符号

## Jumping I-Type

jalr等I-Type跳转指令需要将寄存器中的值与立即数相加的结果写入PC，并且将PC+4写入目标寄存器

将运算结果写入PC的Dadapath已经实现过了，只需要将改变ALU的输入为PortA和imm，将ALU的输出写入PC即可，需要增加的只有将wb这个Mux增加一路输入，代表PC+4

<img src=img\6.png>

## J-Type

不需要增加额外的Datapath，已经可以实现J-Type

> 注意，上面实现的CPU是单时钟周期CPU，一个时钟周期执行一个指令

**指令执行的5个步骤**

1. Instruction Fetch
2. Decode/Register Read
3. Execute
4. Memory
5. Reg Write


