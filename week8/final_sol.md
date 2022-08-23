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
A. 0xfc3000   
B. 0xfffffd000
iv.   
B. Page Hit   
C. DIO
E. Page Fault   
F. Load G into phyisical memory CG...

## 2.TLP
(a) Always Correct, slower than serial    
(b) Always Correct, faster than serial   
(c) Always Correct, faster than serial   
(d) Sometimes Incorrect   

## 3.Pipeline   
(a) BC   
(b) BD   
(c) 3

## 4.SDS.Logic
(a) 4ns   
(b) 39ns   
(c) 152ns   
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
B. S    
iv.    
A. Hit    
B. M    
v.    
A. Miss    
B. S   
vi.    
A. Hit    
B. M    
vii.    
A. Miss    
B. S   
viii.    
A. Hit    
B. M    
(d) 1/2    
(e) 3/4    
(f) 0    
(g) None of the other options

## 7.CALL   
(a) None of the other options   
(b) After the assembler is finished, they are in the same segment 
(c) philspel is in the .text segment of max.s; The address for philspel was resolved.
(d) They are in the same segment.;  sean and jenny will have the same byte difference after linking as it did in jie.o.

## 8.DLP
(a)    
```C
int i = 0;
for(;i+4 < n; i++){
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
i. 2, 3    
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
    lb t1,0(t0)     # left letter
    sub t3,s1,t0
    lb t2,0(t3)     # right letter
    sb t2,0(t0)
    sb t1,0(t3)

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
i. 01110200    
ii. $1*3^{15}+2*3^{14}+2*3^{13}+2*3^{12}+2*3^{11}$    

## 12.I/O
(a)   
i. 1   
ii. uint32_t READY_OUT    
iii. 22   
iv. uint16_t DATA_IN    
(b)    
i. 0xA0000000     
ii.     
```C
uint16_t read_from_pin(int pin){
    uint32_t mask = 0x1;
    mask <<= pin;
    uint32_t flag = mask & IO_device_ptr->READY_IN;
    if(flag == 0){
        return 0;
    }
    uint32_t mask1 = 0xFFFFFFFF ^ mask;
    IO_device_ptr->READY_IN &= mask1;
    return (mask & IO_device_ptr->DATA_IN) >> pin;
}
```
iii.   
```C
void write_to_pin(int pin, uint16_t data){
    uint32_t mask = 0x1;
    mask <<= pin;
    while(!(mask & IO_device_ptr->READY_OUT));
    uint16_t value = IO_device_ptr->DATA_OUT;
    value |= (data << pin);
    IO_device_ptr->DATA_OUT = value;
    uint32_t mask1 = 0xFFFFFFFF ^ mask;
    IO_device_ptr->READY_OUT &= mask1;
}
```

## 13.RISC-V Instruction Format
(a) 4    
(b) 16    
(c) 128   
(d) 0010 0000 1000 xxxx 0101 xxxx xxxx 1000

