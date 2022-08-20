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

### OpenMP
OpenMP包含了一套用于多线程的API


