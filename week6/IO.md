# IO
## 基本IO设备
### 机械硬盘(Magnetic Drives)

<img src=img\1.png>

<img src=img\2.png>

- 磁道(track): 信息存储在磁道中，一面从内到外分成多个磁道
- 扇区(sector): 一个磁道按扇形分成多个扇区（通常一个扇区4kb）

**机械硬盘读写步骤**<br>
- Actuator移动head到指定的磁道，这一步称为seek
- Spindle转动磁盘到指定的扇区，这一步称为rotate

> 磁盘访问时间 = Seek Time + Rotation Tiem + Transfer Time + Controller Overhead

- Seek Time: time to position head to correct track
- Totation Time: time for disk to retate to proper sector
- Transfer Time: time for data to rotate under the head

**平均读写时间**<br>
- Average rotation time为转180度所需时间
- 平均读写移动磁道数：Number of tracks/3
- 平均seek time = 平均磁道移动数 * 移动一个磁道所需时间

```
例: 求平均读写时间
- 900 Tracks with 3ms for the head to cross all 900
- 10000 RPM(Rotation per Minite)
- 1ms controller processing time
- Copy 1MB, transfer rate of 1000MB/s
根据上面公式，有
Disk Access Time = 3ms/3 + 3ms for 1/2 rotation + 1ms + 1ms = 6ms
```

### SSD(Solid State Drives)
- Benifits: lower power, no crashes
- Disk cost = fixed cost of motor + arm mechanics
- Flash cost = most cost/hit of flash chips

## Memory Mapped IO
某一段特殊的物理内存并不用作实际的内存地址，而用于存放IO设备的寄存器，用于与IO设备交互

<img src=img\3.png>

- 每个IO设备对应两种寄存器
  - control register: 对于input设备，用于标志有输入，对于output设备，用于标志可以接受输出
  - data register: 用于存放实际的输入/输出值

IO过程需要解决频率不匹配的问题，即CPU以高频率运转，而输入输出设备的频率可能会很低（如键盘），有以下三种解决方案

## Polling
处理器进入循环等待，直到ready bit = 1

1. Processor reads from control register in a loop, waiting for device to set Ready bit
2. Processor then loads from (input) or writes to (output) data register
3. Resets ready bit of control register

虽然在IO频率已知的情况下，可以在指定的频率下poll，但很多情况下，并没有IO，但CPU仍需耗费时钟周期用于poll

## Interrupts
Use ***exception*** machanism to help trigger I/O, then ***interrupt*** program when I/O is done with data transfer

**Exception, Interrupt, Trap的定义**<br>
- Exception
  - Arises **within** the CPU(e.g. syscall, invalid memory access, illegal instruction, overflow error)
  - Synchronous so must be handled precisely on instruction that raised exception(即一旦发生，就必须在印发exception的指令处处理)
- Interrupt
  - From an **external** I/O controller
  - Asynchronous to current program
  - Can handle whenever it is convenient, though don’t wait too long(即不需要发生了就进行处理)
- Trap
  - **Action** of servicing interrupt or exception by hardware jump to handler code

**Trap的行为**<br>
- Trap例程应保证在被**trapped**的指令之前的所有指令都已完全执行，并且其后的任何指令都没有被执行
- Trap例程应保存PC和寄存器，针对Exception的Trap在执行完后会选择返回程序继续执行或者终止程序，而针对Interrupt的Trap在执行完后必须返回程序继续执行

1. Unexpected event occurs
2. Save the PC and registers
3. Change PC to trap handler
4. Execute handler code
5. Restore registers and PC

> 执行Trap handler时以及返回时，cache都应被置为无效

**如何保存程序的状态**<br>
- 使用CSR(Control and Status Registers)
- 将PC放置在 "sepc" CSR，将引发中断的原因放在 "scause" CSR
- "sscratch" CSR 指向应存放寄存器和PC值的地址位置
- Trap handler程序的首地址被放在 "stvec" CSR中

**Interrupt IO的缺陷**<br>
引发IO interrupt的频率较高，导致IO的效率较低，如假设磁盘没传输16B就要引发一次interrupt，而一次interrupt的处理需要500个时钟周期，这明显是不划算的

## DMA(Direct Memory Access)
- Device controller transfers data directly to/from memory **without involving the processor**
- Only interrupts once per page once transfer is done

<img src=img\4.png>

**DMA Engine**<br>
为了实现DMA，需要额外的硬件支持。使用DMA Engine来实现DMA。现代处理器通常将DMA Engine设计为一个核

DMA过程   
1. Receive interrupt from device
2. CPU takes interrupt, begins transfer
   - CPU告知DMA Engine 相关信息
3. Device/DMA engine handle the transfer
   - 每IO一个大page就interrupt CPU
4. Upon completion, Device/DMA engine interrupt the CPU again

CPU告知DMA engine以下信息   
- Memory address to place data
- Number of bytes to be transferred
- – I/O device number, direction of transfer
- unit of transfer, amount to transfer per burst

<img src=img\5.png>

**DMA引发的问题**

> 如何解决CPU和DMA同时访问内存的问题

- Burst mode
  - Start transfer of data block, CPU cannot access memory in the meantime(一旦DMA工作，CPU不能访问内存)
- Cycle Stealing mode
  -  DMA Engine transfers a byte, releases control, then repeats – interleaves accesses between the two(轮流使用)
- Transparent Mode(最有效)
  - DMA transfer only occurs when CPU is not using the system bus

> 由于DMA能不通过cache直接访问内存，如何解决memory和cache中内容不一致问题

<img src=img\6.png>

这种问题统称caceh coherency，会在之后的章节中讲解

