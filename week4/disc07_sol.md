# DISC 07 sol

## 1 Pre-Check<br>
### 1.1
False. **All units are active in each instrucion**, but the output may be gated.
### 1.2
False. The inputs of the later stages are the outputs of the former stages, which can't be generated if we execute stages in parallel.
### 1.3
False. All of the 5 stages use combinational logic.

## 2 Single-Cycle CPU
### 2.1
(a)顺序为从左到右，从上到下<br>
PC, PCsel, Instruction memory, Register File, Imm generator, Register File write enable, immsel, compare logic, Asel, Unsel, Bsel, less than signal, equal signal, ALU, ALUsel, Data memory, memory write enable, wbsel

(b)<br>
- IF: Send address to the instruction memory (IMEM), and read IMEM at that address.
- ID: Generate control signals from the instruction bits, generate the immediate, and read registers from the RegFile.
- EX: Perform ALU operations, and do branch comparison.
- MEM: Read from or write to the data memory (DMEM).
- WB: Write back either PC + 4, the result of the ALU operation, or data from memory to the RegFile.

### 2.2
|    |BrEq|BrLT|PCSel|ImmSel|BrUn|ASel|BSel|ALUSel|MemRW|RegWEn|WBSel|
|---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|add | * | * | 0 | * | * | 0 |0  | add | 0 |1 | 1 |
|ori| * | * | 0 | ins[31:20] | * | 0 | 1 | or | 0 | 1 | 1 |
|lw| * | * | 0 | ins[31:20] | * | 0 | 1 | add | 0 | 1 | 2 | 
|sw| * | * | 0 | ins[31:25,11:7] | * | 0 | 1 | add | 1 | 0 | * | 
|beq| 0/1 | * | 0/1 | ins[31:25,11:7] | 0 | ~~*~~ 1(PC) | ~~*~~ 1(Imm) | ~~*~~ add | 0 | 0 | * |
|jal| * | * | 1 | ins[ins[31:12] | * | 1 | 1 | add | 0 | 1 | ~~1~~ 0(PC+4) | 
|bltu| * | 0/1 | 0/1 | ins[31:25,11:7] | 1 | * | * | * | 0 | 0 | * |

### 2.3
(a)<br>
|     | IF | ID | EX | MEM | WB | Total Time |
|---: | :---: |:---:|:---:|:---:|:---:|:---:|
| add | yes| yes| yes | no | yes | 600ps |
|ori| yes | yes | yes | no | yes | 600ps |
|lw | yes |yes | yes | yes | yes | 800ps|
|sw | yes |yes |yes | yes | no | 700ps|
|beq |yes |yes |yes| no | no | 500ps|
|jal| yes |yes| yes| no | yes | 600ps |
|bltu| yes | yes | yes | no | no | 500ps |

(b)<br>
lw

(c)<br>
800ps

(d)<br>
Because the fastest clock cycle is restricted by the critical path, which is the longest path in the circuit. It means that if you enhance the overall performance of the instrucions except from the critical path, then it does nothing help to the clock cycle.

> At any given time, most of the parts of the single cycle datapath are sitting unused. Also, even though not every instruction exercises the critical path, the datapath can only be clocked as fast as the slowest instruction.

(e)<br>
Use pipelining, which put registers between adjacent stages.   
The purpose of pipelining: make full use of hardware, which makes instructions can run in parallel, so the clock cycle could be faster.

