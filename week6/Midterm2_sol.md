# Midterm 2 sol
## 1. It's All an Illusion
(a)   
i. 1024   
ii.   
A. ~~512~~ 8192

> \# of PTE = $\frac{2^{36}}{2^{12}} = 2^{24}$  
> \# of pages = $\frac{2^{24}}{2^{11}} = 2^{13} = 8192$

B. 4    
(b)   
True

> Each process has its own page table. Thus, the process needs to flush the TLB on context switching which will lead to increasing the context switching time.



## 2. Sunay-Cycle Datapath
(a)   
i.   
A. PC+4   
B. Write   
C. *   
D. *   
E. RS1   
F. Imm   
G. ADD   
H. Read   
I. Mem   
ii.   
A. ALU   
B. Do Not Write   
C. 0   
D. 0   
E. PC   
F. Imm   
G. ADD   
H. Read   
I. *   
iii.   
A. PC+4   
B. Do Not Write   
C. *   
D. *   
E. RS1   
F. Imm   
G. ADD   
H. Write   
I. *   
(b)    
i.   
A. *   
B. *   
C. Write   
D. Read   
E. RS1   
F. PC+4  
G. ALU   
(c)   
i. A  
ii. C
iii. D   
iv. BC   

## 3. Hazardous Situa-Seans
(a)   
i. 0   
ii. ~~0~~ 1

> 前一条指令的写入在W阶段，后一条指令的读取在D阶段


iii. ~~1~~ 2   
iv. 0   
(b)    
i. ~~4~~ 6

> data hazard * 2 + control hazard * 1

ii. 1   

## 4. Monry
(a)   
i.   
A. 26   
B. 0   
C. 6   
ii.   
A. 20   
B. 6     
C. 6   
iii.    
A. 22    
B. 4   
C. 6   
(b) ~~1/3~~ 62/189

> A[16] Miss B[0] Miss A[0] Miss   
> A[32] Miss B[0] Miss A[16] Hit   
> 后面都是两个Miss 一个Hit   
> 只有第一排是三个Miss

(c) 4-way   
(d)   
i. ~~1/3~~ 62/189   
ii. ~~1/2~~ 61/127   

> A[16] Miss B[0] Miss A[0] Miss  
> A[32] Miss B[16] Miss  
> A[48] Hit B[32] Miss   
> A[64] Miss B[48] Hit  
> A[80] Hit B[64] Miss  
> 后面就是A Hit B Miss和A Miss B Hit交替

(e) 24ns   

## 5. HOld on, this Logic isn't that Hard-ware
(a) ~~B(~(AC))(B+C)~~  A*C+~B       
(b)    
i.    
A. 16ns   
ii.   
A. 76.92MHz    
B. ~~2ns~~ 5ns

> clk-to-q + AND

## 6. What's Your Wi-Fi Password?
(a) 0    
(b) 0   
(c) 0   
(d) 0    
(e) 2    
(f) 1    
(g) 1    
(h) 2    
(i) 2    
(j) 0    
(k) 1    
(l) 0   
