# DISC 08 sol
## 1 Pre-Check
### 1.1
~~False. Pipelining doesn't shorten the latency of a single instrucion.~~

True. Recall that latency is the time for one instruction to finish, while throughput is the number of instructions processed per unit time. Pipelining results in a higher throughput because more instructions are run at once. At the same time, latency is also higher as each individual instruction may take longer from start to finish because each cycle must last as long as the longest cycle. Additionally, hazards may be introduced.

### 1.2
False. If the register file use double pumping, then data hazards could only result in 2 stalls.

### 1.3
False. Even use forwarding, the store-use data hazard results in 1 stall.

### 1.4
1. stall
2. branch prediction, such as static prediction and dynamic prediction

## 2 Pipelining Registers
### 2.1
Store the necessory informations that are needed by the following stages.

### 2.2
Because both PC and PC + 4 are needed in following stages, the former is used in EX, the later is used in WB, so if we don't add +4 to PC twice, there would be both PC and PC+4 in the registers, which we don't want.

### 2.3
Because we need to fetch informations from the instruction in every stages. For example, get control signals. And if the instrucion want to write back to the register, we use the field in the instruction to specify the destination register.

## 3 Performance Analysis
### 3.1
~~instrucion memory(250) + immGen(ALU 200) + Mux(25) + ALU(200) + Memory read(250) + Mux(25) = 950ps~~

PC clk-to-q(30) + IMEM read(250) + RegFile read(150) + mux(25) + ALU(200) + DMEM read(250) + mux(25) + RegFile setup(20) = 950ps

### 3.2
EX: clk-to-q(30) + Mux(25) + ALU(200) + setup(20) + **mux(25)** = 275ps

> 最后加一个mux是为了选择ALU的输出

### 3.3
3.2    
Because the time for each stage is different. And the minimum clock cycle is the longest stage

> The speedup is less than 5 because of (1) the necessity of adding pipeline registers, which have clk-to-q and setup times, and (2) the need to set the clock to the maximum of the five stages, which take different amounts of time.

## 4 Hazards
### 4.1
There are 2 data hazards, between instruction 1 and 2, and between instructions 1 and 3. The first could be resolved by forwarding the result of the EX stage in C3 to the beginning of the EX stage in C4, and the second could be resolved by forwarding the result of the EX stage in C3 to the beginning of the EX stage in C5.

### 4.2
3 if no double-pumping, 2 if double-pumping

### 4.3
There are two data hazards in the code. The first hazard is between instructions 2 and 3, from t0, and the second is between instructions 3 and 4, from t1. The hazard between instructions 2 and 3 can be resolved with forwarding, but the hazard between instructions 3 and 4 cannot be resolved with forwarding. This is because even with forwarding, instruction 4 needs the result of instruction 3 at the beginning of C6, and it won’t be ready until the end of C6.


### 4.4
```
2-3-1-4
```

### 4.5
Use branch prediction. Simply you can always predict that the branch will not take place, so you can fetch the instructions in sequence. If the branch instruction actually failed, there is nothing to do. If the branch take place, the following instructions should be replaced by bubble, and the PC should be the address branching to.

### 4.6
4 hazards, 3 data hazards, 1 control hazard.   
4 stalls       
> No stalls are needed for the control hazard, because it can be handled with branch prediction/flushing the pipeline.


