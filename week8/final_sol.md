# Final sol
## 1.Virtual Memory
(a)    
i.    
A. 12   
B. 20    
C. 12    
D. 32    
(b)   
i.     
A. 64   
B. 4096   
ii. 3    
iii.   
A. 0xfc2000   
B. 0xffffd000
iv.   
B. Page Hit   
C. DIO
E. Page Fault   
F. CGP, because there is no arrow point to P

## 2.TLP
(a) ~~Always Correct, slower than serial~~ Sometimes Incorrect
> 将dot_product**声明为private**导致错误，结束for循环后，dot_product一定为0，因此只有当正确结果也为0的情况下才正确 

(b) Always Correct, faster than serial   
(c) Always Correct, faster than serial & Always Correct, slower than serial   

> 理论上的答案应该是slower than serial，如果array是block-aligned(即放在block的起始位置)由于**false sharing**的缘故，四个线程的cache会不断kick off dps所在的block，导致效率下降   
> 然而在实际中，array可能只是word-aligned的，导致dps可能横跨两个block，从而使得效率提高

(d) Sometimes Incorrect   

## 3.Pipeline   
(a) ~~B~~ C  

> B错误的原因是，应该为$\ge 3$而不是 $> 3$

(b) BD   
(c) 3

## 4.SDS.Logic
(a) ~~4~~ 18    

> clock-to-q + NOT + AND = 18

(b) ~~39~~ 42   

> critical path应该是x_input到reg1,注意x_input的条件

(c) 102ns   
(d) 41ns   

## 5.Single Cycle Datapath
(a)   
i. Branch comparator   
ii. DMEM    
(b)    
i. A   
ii. C   
iii. DG   

## 6.Cache and MOESI
(a) False    
(b)    
i. 4   
ii. 2   
iii. 14    
(c)    
i.    
A. Miss   
B. E   
ii.   
A. Hit   
B. M   
iii.   
A. Miss    
B. O    
iv.    
A. Hit    
B. M    
v.    
A. Miss    
B. O   
vi.    
A. Hit    
B. M    
vii.    
A. Miss    
B. O   
viii.    
A. Hit    
B. M    
(d) 1/2    
(e) 3/4    
(f) 0    

> As the array fits perfectly into the cache, we never need to evict an block and write-back

(g) ~~None of the other options~~ Letting processor 0 start and finish, then processor 1 starts and finishes && Letting processor 1 start and finish, then processor 0 starts and finishes    

> MHHH循环

## 7.CALL   
(a) ~~None of the other options~~ They are referenced before they are defined.

> 本题或许说明了，在pass1中，会将所有推断不出来的label放入relocation table中，如果pass2解决了某一label，便会将其从relocation table中弹出

(b) After the assembler is finished, they are in the same segment 
(c) philspel is in the .text segment of max.s; The address for philspel was resolved.
(d) They are in the same segment.;  sean and jenny will have the same byte difference after linking as it did in jie.o. **sean and jenny are in different sections of jie.s.**

## 8.DLP
(a)    
```C
int i = 0;
for(;i+4 < n; i+=4){
    temp = load_epi32(&arr[i]);
    int local_max = reducemax_epi32(temp);
    if(local_max > running_max){
        running_max = local_max;
        vec tmp = maskeq_epi32(temp,running_max);
        index = firstv_epi32(tmp) + i;
    }
}
for(;i<n;i++){
    if(arr[i] > running_max){
        running_max = arr[i];
        index = i;
    }
}
```

## 9.ECC, RAID
(a) RAID 5, RAID 1, RAID 4    
(b) RAID 0   
(c)    
i. 3    
ii. 120    
iii.   
A. 001001110100    
B. 1    

## 10.RISC-V Coding
(a)   
```
Reverse_str:
    # save registers

    mv s0,a0
    mv s1,a1
    addi t0,x0,0
Loop:
    add t4,t0,s0
    lb t1,0(t4)     # left letter
    sub t3,s1,t0
    addi t3,t3,-1   # 这里要-1
    addi t3,t3,s0
    lb t2,0(t3)     # right letter
    sb t2,0(t4)
    sb t1,0(t3)

    addi t0,t0,1
    srli t3,s1,1
    blt t0,t3,Loop

    # restore registers
    ret
```

## 11.Number Rep
(a)   
i. 43   
ii. 1121   
(b)  
i. ~~01110200~~ 01110201    
ii. $1*3^{15}+2*3^{14}+2*3^{13}+2*3^{12}+2*3^{11}$    

## 12.I/O
(a)   
i. 1   
ii. uint32_t READY_OUT    
iii. ~~22~~ 61

> 16进制

iv. uint16_t DATA_IN    
(b)    
i. base_io_addr + 0x100   
ii.     
```C
uint16_t read_from_pin(int pin){
    if((IO_device_ptr->READY_IN >> pin) & 1){
        return IO_device_ptr->DATA_IN;
    }
    return 0;
}
```
iii.   
```C
void write_to_pin(int pin, uint16_t data){
    IO_device_ptr->READY_OUT = IO_device_ptr->READY_OUT | (1 << pin);
    IO_device_ptr->DATA_OUT = data;
}
```

## 13.RISC-V Instruction Format
(a) 4    
(b) 16    
(c) 128   
(d) 0010 0000 1000 xxxx 0101 xxxx xxxx 1000

