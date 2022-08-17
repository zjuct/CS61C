# DISC 10 sol
## 1 Pre-Check
### 1.1
False. Similar concepts apply to almost all types of applications, including web apps, mobile apps, distributed systems, and so on.
### 1.2
False. It can also work with interrupt and DMA
### 1.3
False. OS doesn't response for combining programs together.
### 1.4
True
### 1.5
True

## 2 Polling & Interrupts
### 2.1
|Operation |Defination |Pro/Good for|Con |
|:---|:---|:---|:---|
|Polling |looping until ready bit of control register of the IO device is set, then read from/write to data register and reset the ready bit|1. Low Latency<br>2.Low overhead when data is available<br>3. • Good For: devices that are always busy or when you can’t make progress until the device replies|If the frequency of IO request is low, then the CPU will waste a lot of cycles for loop|
|Interrupts|Interrupts are triggered by external IO devices when the ready bit is set, then current program will be trapped into trap handler. When the trap handler finish IO, then the previous program will continue.|CPU doesn't need to wait when there is no IO request. It only need to handle IO when interrupted.|If the data transferred per interrupt is low(16B maybe), then the effenciency is low.|

## 3 Memory Mapped I/O
### 3.1
```
# return value: a0 is the data read
read:   
    li t0, FFFF0000
    li t1, FFFF0004
loop:
    lb t2,0(t0)
    andi t2,t2,1
    beq t2,x0,loop
    lb a0,0(t1)
# arg: a0 is the data written
write:
    li t0,FFFF0008
    li t1,FFFF000C
loop:
    lb t2,0(t0)
    andi t2,t2,1
    beq t2,x0,loop
    sb a0,0(t1)
```

## 4 Forking
fork()  
pid == 0

