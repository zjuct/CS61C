# Parallelism

**五种并行**<br>
- Parallel Requests
- Parallel Threads
  - MIMD(Multi instructions multi data)的实现方式
- Parallel Data
  - SIMD(Single instrucion multi data)的实现方式
- Parallel Instrucions
  - 前面的流水线
- Hardware descriptions
  - All gates functioning in parallel at same time

**Flynn's Taxonomy**<br>

<img src=img2\1.png>

- SISD: 前面搭建的流水线CPU就属于SISD
- SIMD: 一个指令同时对多个数据进行处理，比如SSE对向量进行操作（可以通过添加多个ALU实现），以及GPU同时处理多个像素点
- MISD: 现实中不使用
- MIMD: 同时执行多个指令，每个指令又同时对多个数据进行处理。如多核CPU

## SIMD Architectures

SIMＤ架构实现了Data-Level Parallelism(DLP)

<img src=img2\2.png>

- SIMD的基本思想是将多个数据当作一个向量来进行处理
- x86架构包含SSE(后来变成AVX)指令集，其主要操作对象为向量寄存器(大小为128/256/512 byte)，每个向量可以根据实际数据类型存放不同的数据
  - 如128大小的向量可以存放4个int，4个fload或者2个double

### 基本SSE指令(SSE Intrinsics)

帮助手册在Intel Intrinsics Guide中

- Intrinsics are C functions and procedures that translate to assembly language, including SSE instructions
- One-to-one correspondence between intrinsics and SSE instructions

```C
/*
若想使用SSE，要包含nmmintrin.h
向量类型以 __m开头，其后为大小，如__m128i为大小128byte的向量
函数以_mm_开头，中间为操作类型，最后是向量中的实际元素
*/

__m128i _mm_setzero_si128();    //返回一个大小为128byte的空向量
__m128i _mm_loadu_si128(__m128i *p);    //将p指向位置当作一个128byte的向量返回
__m128i _mm_add_epi32(__m128i a, __m128i b);    //两个向量对应位置相加（向量元素为epi32), epi32 为Extended Packed Integer,即32位int
void _mm_storeu_si128(__m128i *p, __m128i a);   //将向量a保存到p指向的位置
__m128i _mm_cmpgt_epi32(__m128i a, __m128i b);  //cmpgt为compare greater than, ret_i = a_i > b_i ? 0xffffffff: 0x0，即创建蒙版
__m128i _mm_and_si128(__m128i a, __m128i b);    //对应元素做and运算
```

例：使用SSE进行数组对应位置元素相加
```C
//没有SSE的版本
int add_no_SSE(int size, int *first_array, int *second_array) {
    for (int i = 0; i < size; ++i) {
        first_array[i] += second_array[i];
    }
}
//SSE版本
int add_SSE(int size, int *first_array, int *second_array) {
    for (int i=0; i + 4 <= size; i+=4) { // only works if (size%4) == 0
        // load 128-bit chunks of each array
        __m128i first_values = _mm_loadu_si128((__m128i*) &first_array[i]);
        __m128i second_values = _mm_loadu_si128((__m128i*) &second_array[i]);
        // add each pair of 32-bit integers in the 128-bit chunks
        first_values = _mm_add_epi32(first_values, second_values);
        // store 128-bit chunk to first array
        _mm_storeu_si128((__m128i*) &first_array[i], first_values);
    }
}
```

## MIMD Architectures
MIMD有两种实现方式
1. Use multiple cores to run multiple tasks in parallel（即多核）
2. Run multiple tasks on a single core concurrently（即多线程）

### Multiprocessor Systems

<img src=img2\3.png>

- 每个进程（或者核心）包含自己的PC和registers
- 每个进程的指令流是不同的
- 所有的进程（处理器核心）共享同一块内存
- 多个进程可以通过对同一内存地址的读取来进行交互

### Multi-thread

<img src=img2\4.png>

- 所有的线程包含独立的
  - PC
  - Registers
  - Stack memory
- 一个进程的所有线程共享
  - Code memory
  - Static memory

<img src=img2\5.png>

**Data Races**<br>
- 由于线程的调度是不确定的，那么如果多个线程修改的同一个变量，那么变量的最终值就是不确定的，这被称为data race

使用**上锁**(Lock Synchronization)的方式来实现同步访问

- Use a "Lock" to grant access to a region(critical section) so that only one thread can operate at a time
- 由于锁需要被所有的处理器共享，因此锁应放在内存的共享区域
- 线程读取锁的值，如果锁上了（锁的值为1），则循环等待（**自旋**）；如果没锁上（锁的值为0），则上锁并进入critical section

下面是一种**不正确**的方式
```
//错误示范
while(lock != 0){
  lock = 1;   //set lock
  // critical section
  lock = 0;  //release lock
}
```
- 错误原因在于lock本身也是共享数据，如果thread 1在进入while循环后直接转为thread 2，此时由于lock = 1仍未执行，thread 2也能进入循环，引发data race 
- 在软件层面，无论加上几层锁都是无济于事的，因为无论加上几层锁，这些锁都在共享区域内

**解决Data Races, 使用AMO**<br>
RISC-V支持AMO(Atomic Memory Operation)指令，这些原子指令可以在一个时钟周期内完成内存的读和写

```
amoadd.w rd,rs2,(rs1)
# 伪码描述如下
# temp = M[R[rs1]]
# R[rd] = temp
# M[R[rs1]] = temp + R[rs2]
```

每个原子指令都支持两个后缀  
- aq(acquiring lock): 直到这条指令**执行完毕**，不执行其后所有的内存访问指令
- rl(releasing lock): 在这条指令**执行前**，将其之间所有内存访问指令执行完毕

正确的上锁方式如下
```
# 假设a0存放锁的内存地址
  addi t0, x0, 1
Try:
  amoswap.w.aq t1, t0, (a0) # 将M[a0]的原始值放入t1，将t0的值(1)放入M[a0]
  bnez t1, Try  # 如果t1的值为1，则说明锁已经被其它线程锁上，此时将1放入M[a0]无影响；如果t1的值为0，则amoswap将锁锁上，可以执行critical section
  # .aq是为了不提前执行critical section
  # critical section
  amoswap.w.rl x0, x0, (a0) # 将锁释放， .rl是为了确保critical section执行完全
```


### OpenMP
OpenMP包含了一套用于多线程的API

```C
//例: Parallel Hello World
#include<stdio.h>
#include<omp.h>
int main(){
  int nthreads, tid;
  #pragma omp parallel private(pid)
  {
    tid = omp_get_thread_num();
    printf("Hello World from thread = %d \n",tid);
    if(tid == 0){
      nthreads = omp_get_num_threads();
      printf("Number of threads = %d\n",nthreads);
    }
  }
}

```

```C
//例2: 使用多线程加速矩阵乘法
//只有第一个for循环被分为多个线程
#pragma omp parallel for private(tmp,i,j,k)
  for(i = 0;i<Mdim;i++){
    for(j = 0;j<Ndim;j++){
      tmp = 0;
      for(k = 0;k<Pdim;k++){
        tmp += *(A+(i*Pdim+k))* *(B+(K*Ndim+j));
      }
      *(C+(i*Ndim+j))=tmp;
    }
  }
```

## Synchronization Problems
指多线程引发的data race问题

```C
//sum会引发data race
double compute_sum(double* a, int a_len){
  double sum = 0;
  #pragma omp parallel for
  for(int i = 0; i< a_len;i++){
    sum+=a[i];
  }
  return sum;
}
```

解决方法是使用分治(Reduction)，即每个线程先算出自己的局部和，再在线程合并时将所有局部和相加得到全局和

OpenMP自带的Reduction语法如下
```C
reduction(operation: var)
// Operation: 在合并时对所有部分var进行的操作,可以是+ * | & 等
// var: 需要分治的变量，对于上面的例子来说就是sum
```
使用reduction来求和
```C
#pragma omp for reduction(+ : sum)
for(int i = 0;i<a_len;i++){
  sum += a[i];
}
```

## OpenMP 引发问题

并不是所有情况都可以无脑使用多线程来提高效率，在遇到下面的几种情况时，要谨慎（或者不能）使用多线程

- Data dependencies
- Sharing issues
- Updating shared values
- Parallel overhead

### Data Dependencies
指一个线程的求值依赖于其它线程的运算结果，该问题源于线程的调度情况是完全不确定的

```C
//错误样例:违反 Data Dependencies
a[0] = 1;
#pragma omp for parallel
for(int i = 1; i<5000;i++){
  a[i] = i + a[i-1];
}
```

### Sharing Issues
指对变量的私有性和共享性设置错误

```C
//错误样例:未将temp 设置为私有
#pragma omp parallel for
for(int i = 0;i<n;i++){
  temp = 2*a[i];
  a[i] = temp;
  b[i] = c[i] / temp;
}
//将temp设置为私有就正确了
```

### Updating shared values
指原本在单线程下连续的读写操作，在多线程时会被其它线程打断，从而引发变量值的错误

```C
//错误样例:sum的值不定
#pragma omp parallel for
for(int i = 0;i<n;i++){
  sum = sum + a[i];
}
//正确:将sum 设置为reduction
#pragma omp parallel for reduction(+ : sum)
{
  for(int i = 0;i<n;i++){
    sum = sum + a[i];
  }
}
```

### Parallel Overhead
指生成线程和销毁线程时的开销

解决方式:增大每个多线程区域，减少总体多线程区域数量

```C
//对最内层循环多线程，频繁生成和销毁线程，效率差
for(i = 0;i<Mdim;i++){
  for(j = 0;j<Ndim;j++){
    tmp = 0;
    #pragma omp parallel for reduction(+ : tmp)
    for(k = 0;k<Pdim;k++){
      tmp += *(A+(i*Pdim+k))* *(B+(K*Ndim+j));
    }
    *(C+(i*Ndim+j))=tmp;
  }
}
```


## Cache Coherency
- 对于Multiprocessor，每个processor都有自己的Cache（L1 Cache）
- 如果按照原先的单线程cache，如果同一个block同时在两个cache中，此时thread 1写入该block，改变了其值，那么此时thread 2对应cache中的该block就已经是out of date了
- Cache coherency就是要使所有cache中同一block的值保持一致，通过interconnection network和MOESI协议实现

### MSI协议
对于每个cache的每个block，使用三个bit来标志该block的状态

- Modified: up-to-date, changed(**dirty**), OK to write. 即是该thread修改了block的值
  - no other cache has a copy(其它cache中若有该block，则都是out-of-date)
  - copy in memory is out-of-date(使用write-back策略)
  - must respond to read request by **other processors** by **updating memory**(即当其它processor请求该block时，需要更新memory，然后将该block送入对应的cache)
- Shared: up-to-date, not allowed to write
  - other caches may have a copy
  - copy in memory is up-to-date(即多个cache都包含同一个up-to-date的block)
- Invalid: data in this block is "garbage"

**MSI协议状态图**<br>

对自身Processor读写请求的状态变化响应

<img src=img2\6.png>

- Invalid状态下响应Read Miss，此时从memory中获取up-to-date的block，该block进入shared状态
- Shared状态下Write Hit，则当前cache中的该block变为唯一up-to-date的版本，且memory变为out-of-date，进入Modified状态
- Invalid状态下响应Write Miss，则从memory中读取该block，memory变为out-of-date，进入Modified状态
- Shared状态下响应Read Hit，以及Modified状态响应Read/Write Hit，状态不变

其它processors对该block进行读写（称为Probe Read/Write），当前cache响应图

<img src=img2\7.png>

- Shared状态下，响应Probe Write Hit，则当前cache的该blcok已经是out-of-date，进入Invalid状态
- Modified状态下，响应Probe Write Hit，则其它cache覆盖了当前cache的写，进入Invalid状态
- Modified状态下，响应Probe Read Hit，则需要将被修改的block写回内存，再从内存读到对应的cache，两个block都为shared状态

每个block通过三个bit来决定状态

<img src=img2\8.png>

**Compatibility Matrix**     
指同一block在两个cache中可能取到的状态  

<img src=img2\9.png>

- 不可能都为Modified，或一个为Modified另一个为Shared，因为将一个block置为Modified，则其它cache中的该block应被置为Invalid

MSI协议的缺陷    

- 当Write处于Shared状态的block时，需要检查其它cache，将对应block置为Invalid
- 当其它cache需要read处于Modified状态的block时，需要经过内存绕一圈

### MESI协议
MESI协议在MSI协议的基础上增加了Exclusive状态   
- Exclusive: up-to-date, OK to write
  - **no other cache has a copy**(该block由当前cache独有)
  - copy in memory is up-to-date(即没有被写入)
  - no write to memory if block replaced
  - supplies data on read instead of going to memory(其它cache需要read时，首先检查其它cache是否已经有处于exclusive状态的该block，若有，则不需要经过内存)
- Shared: 修改为other caches **must** have a copy

对自身Processor读写请求的状态变化响应

<img src=img2\10.png>

- Invalid状态下响应Read Miss，如果当前cache是唯一含有该block的cache，则进入状态Exclusive
- Invalid状态下响应Read Miss，如果其它cache已经有该block，则**不需要访问内存**，直接从其它cache中获取block，进入状态Shared
- 一旦发生写入，进入状态Modified

对其它Processors读写的响应

<img src=img2\11.png>

- Exclusive状态下响应Probe Read Hit，则两个cache共享该block，进入Shared状态
- Modified状态下响应Probe Read Hit，与MSI相同，也需要先写回内存
- 一旦发生Probe Write Hit，进入Invalid状态

标志位

<img src=img2\12.png>

- 相比MSI，Shared的Shared Bit一定为1
- Exclusive不发生写入，也不与其它cache共享

MESI协议缺陷

- 其它cache Read Modified状态的block时，需要先写回内存

### MOESI协议
相比MESI，增加Owner状态
- Owner: up-to-date, read-only(like shared, you can write if you invalidate shared copies and your state changes to modified)
  - Other caches have a **shared copy**(Shared state)
  - Data in memory not up-to-date
  - Owner supplies data on probe read instead of going to memory
  - Combination of Modified and Shared
  - Owner状态为dirty block的提供者，其它与之共享的cache含有的只是shared copy
  - Shared副本的dirty bit为0，也就是说将shared副本替换时不发生内存写入，内存写入只在Owner被替换时发生
- Shared: up-to-date, not allowed to write
  - other caches must have a copy
  - copy in memory **may** be up-to-date(即可能为dirty copy)

对自身Processor读写请求的响应

<img src=img2\13.png>

- Owner状态响应Write Hit，自身变为Modified，其它cache的Shared副本变为Invalid
- Owner状态无法通过自身的读写到达

对其它Processors读写的响应

<img src=img2\14.png>

- Modified状态下响应Probe Read Hit，自身变为Owner，请求Read的cache获得Shared副本（不需要访问内存）
- 其它cache对Shared副本Write Hit时，当前Owner状态失效(不再是up-to-date)，变为Invalid

标志位

<img src=img2\15.png>

兼容矩阵

<img src=img2\16.png>

> MOESI协议实现了多处理器情况下与单处理相同的内存写入，即只有当dirty bit为1的block被正常替换时才写回内存，而不需要任何额外写入

