# CALL<br>
> CALL: Compiler Assembler Linker Loader

```
            C program: foo.c
                    |
                Compiler
                    |
        Assembler program: foo.s
                    |
                Assembler
                    |
              Object: foo.o
                    |___lib.o
                    |
                  Linker
                    |
            Executable: a.out
                    |
                  Loader
                    |
                  Memory
```

## Compiler<br>
- Input: Higher-level language(HLL) code
- Output: Assembly Language Code
- The output may contain **pseudo-instrctions**
- The interpretation of macro is beyond compile, which is in the preprecessor step

## Assembler<br>
- Input: Assembly Language code
- Output: Object code, imformation tables

汇编器阅读并使用Directives和Lables，并且将伪指令替换，产生机器码

**Assembler Directives**<br>
- .text: 声明连续代码段的起始
- .data: 声明连续数据段的起始
- .globl sym: sym标签可以被其它文件引用
- .import filename.s: 包含其它文件，使得文件中被声明为globl的标签可以被使用
- .asciiz str: 在内存中存放str，并且以空字符结尾
- .word $w_{1},...,w_{n}$: 存放多个连续的word

Assembler在汇编时会遇到四个问题<br>
1. Forward Reference，在brahch指令和jal指令中使用的标签可能在下文才出现
2. 使用jal等跳转到外部文件中的label，但在汇编本文件时并不知道外部标签对应的地址
3. 使用la(被翻译为lui+addi或者auipc+addi)时，必须知道绝对地址
4. .data段和.text段是分离的，在汇编时，汇编器并不知道实际链接后数据段的位置

对于问题1<br>
Assembler对汇编源代码进行两次遍历，第一次遍历时记录源代码中出现的所有Label，在第二次遍历时对指向本文件的Label进行替换

对于问题2,3,4<br>
Assembler先将机器码指令中的地址位用占位符填充起来（比如全0），然后创建一个Relocation Table，代表需要由Linker在获取绝对地址后进行重定向的所有item

Assembler一共创建两张表<br>
**Symbol Table**<br>
Symbol Table记录其它文件中可能使用的信息<br>
- Labels: 记录函数对应的相对地址
- Data: 记录.data段中定义的变量（类似全局变量）

**Relocation Table**<br>
Relocation Table记录所有Assmbler不能确定的地址，这些地址需要由Linker填充<br>
- External Label: jal使用
- Data: 数据段中Label对应的地址（.data和.text的实际位置由Linker决定）

**Object File Format**<br>
Object File包含以下六个内容
1. Object File Header: 含有文件信息，如其它5个部分的大小和位置
2. text segment: 代码段（保存机器码）
3. data segment: .data中定义的内容
4. relocation table: 包含需要由Linker填充的地址
5. symbol table: 可由其它文件所使用的Label和data的地址
6. debugging information: 如gcc -g 产生的信息

Assembler对汇编源代码进行两次遍历<br>
- Pass1: 
  - 替换伪指令
  - 构建符号表
  - 去除注释和空行
  - 检查错误
- Pass2:
  - 利用符号表产生相对地址偏移量
  - 生成object file


## Linker<br>
- Input: Object Code files, information tables
- Output: Executable Code

Linker一共做三件事<br>
1. 将所有.o文件的代码段合并为一个代码段
2. 将所有.o文件的数据段合并为一个数据段，将其放置在代码段的后面
3. 解决Reference，读取每个.o文件的Relocation table，填充所有地址

**RISC-V的三种寻址方式**<br>
PC-Relative Addressing(PC相对寻址)<br>
由beq, bne等branch指令和jal使用<br>
- 不进行重定向（因为相对地址是固定的）

External Function Reference(外部函数引用)<br>
通常由jal使用<br>
- 进行重定向（因为各个代码段的位置需要由Linker重新编排）

Static Data Reference(静态数据引用)<br>
通常由la(auipc+addi)使用<br>
- 进行重定向（因为数据段位置会被Linker重新安排）

**Linker如何解决Referneces问题**<br>
- 在RV32中，Linker假设第一个.o文件的第一个代码段的第一个word的位置为0x10000，据此，可以由相对地址推算出绝对地址（假设为0x10000与虚拟内存有关）
- Linker知道每个代码段和数据段的长度，以及各个段的位置顺序
- 根据上面两点，Linker可以推算出外部函数引用的相对地址，以及需要的绝对地址

## Loader<br>
- Input: Executable Code
- Output: \<program is run\>

在现实中，Loader就是操作系统

1. 读取可执行文件的文件头，获取代码段和数据段的大小
2. 根据各个段的大小分配空间，同时分配栈段
3. 将可执行文件中的数据拷贝到新分配的内存空间
4. 将程序的参数拷贝到栈中
5. 初始化寄存器，大部分寄存器清零，SP指向栈底
6. 跳转到start-up routine，将栈段中的参数拷贝到对应的寄存器中，将PC设置为第一条指令的位置，开始执行。当最后使用系统调用结束程序时，start-up routine接管程序并结束执行