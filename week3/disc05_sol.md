# DISC05 sol<br>
## 1 Pre-Check<br>
### 1.1<br>
True<br>
### 1.2<br>
> 1.2 The main job of the assembler is to generater ***optimized*** machine code.

~~True~~<br>

> False. 这题的关键在于**optimized**，对代码的调优是complier的工作，assembler只是将汇编指令翻译为对应的机器码指令

### 1.3<br>
False. The linker needs to relocate all absolute address references.

### 1.4<br>
> 1.4 The destination of all jump instructions is completely determined ***after*** linking.

False. (答非所问)~~The jal instruction which jump to labels in the current file will be determined before linking. And all of the jalr instructions will be determined by the assembler.~~

> False. jalr are only known at run-time.

## 2 CALL<br>
### 2.1<br>
The program can be represented by bits, just like datas, and can be loaded into the memory to be executed. ~~It enables us to cheat programs and datas as the same.~~ This enables us to write programs that can **manipulate other programs** without modifying the physical hardware.

### 2.2<br>
Two. One to find all the label addresses, and another to convert all instructions while using these label addresses to resolve any forward references.

### 2.3<br>
- Header: Contains the position and size of the other five parts.
- Text: The machine code assembled by the assembly language.
- Data: Binary representation of the data in the .data segment.
- Relocation Table: Indentifies lines of code that would be relocated later by the linker.
- Symbol Table: Datas and Labels that could be referenced by other files.
- Debugging Information: Addtional information for debuggers.

### 2.4<br>
assembler, linker.

## 3 Assembling RISC-V<br>
### 3.1<br>
5,6,7,14,15

### 3.2<br>
~~No label will be resolved in the first pass. end,loop will be resolved in the second pass.~~

第一轮pass会处理backward reference, 即loop. 第二轮pass处理forward reference，即end

### 3.3<br>
~~array, sum, loop, end.~~

> 只有sum及其地址

### 3.4<br>
array, print_int

## 4 RISC-V Addressing<br>
### 4.1<br>
$[-2^{10},2^{10}-1]$

### 4.2<br>
$[-2^{18},2^{18}-1]$

### 4.3<br>
0000000 00101 00111 000 00110 0110011<br>
0 **0000010100** 0 00000000 00001 1101111<br>
1111111 00000 00110 001 **11001** 1100011<br>
0x002cff08

注意SB-format和J-format

