# DISC 09 sol
## 1 Pre-Check
### 1.1
True. A 4-way set associative cache will have 2 index bits fewer than a direct-mapped cache.
### 1.2
~~True~~   
> False. When the cache is full, you can still get compulsory misses( when a block of data is put in the cache for the first time) and conflict misses( if a fully associative cache with LRU replacement wouldn't have missed) 
### 1.3
False. Whether this improves the hit rate for a given program depends on the characteristics of the program

## Understanding T/I/O
### 2.1
4,3
### 2.2
TAG:31:5   
offset:2:0
### 2.3
|Address |T/I/O|Hit,Miss,Replace|
|:---|:---|:---|
|0x00000004|000000000000000000000000000 : 00 : 100|Miss|
|0x00000005|000000000000000000000000000 : 00 : 101|Hit|
|0x00000068|000000000000000000000000011 : 01 : 000|Miss|
|0x000000C8|000000000000000000000000110 : 01 : 000|Miss,Replace|
|0x00000068|000000000000000000000000011 : 01 : 000|Miss,Replace|
|0x000000DD|000000000000000000000000110 : 11 : 101|Miss|
|0x00000045|000000000000000000000000010 : 00 : 101|Miss,Replace|
|0x00000004|000000000000000000000000000 : 00 : 100|Miss,Replace|
|0x000000C8|000000000000000000000000110 : 01 : 000|Miss,Replace|

## 3 Cache Associativity
### 3.1
|Address |T/I/O|Hit,Miss,Replace|
|:---|:---|:---|
|0b0000 0100|0000 : 0 : 100|Miss|
|0b0000 0101|0000 : 0 : 101|Hit|
|0b0110 1000|0110 : 1 : 000|Miss|
|0b1100 1000|1100 : 1 : 000|Miss|
|0b0110 1000|0110 : 1 : 000|Hit|
|0b1101 1101|1101 : 1 : 101|Miss,Replace|
|0b0100 0101|0100 : 0 : 101|Miss|
|0b0000 0100|0000 : 0 : 100|Hit|
|0b1100 1000|1100 : 1 : 000|Miss,Replace|

### 3.2
1/3

## 4 The 3 C's of Cache Misses
**注意**
- 不管在FA cache中是否会miss,只要在这个cache中，该block是首次遇到的，那么就是compulsory，这是第一次判断
- 判断Capacity还是Conflict要将**整个**内存的访问序列应用到FA cache中，如果FA cache也会miss，那么就是Capacity，这是第二次判断
- FA cache采用LRU replacement policy

|Address |T/I/O|Hit,Miss,Replace|
|:---|:---|:---|
|0x00000004|000000000000000000000000000 : 00 : 100|Compulsory|
|0x00000005|000000000000000000000000000 : 00 : 101|Hit|
|0x00000068|000000000000000000000000011 : 01 : 000|Compulsory|
|0x000000C8|000000000000000000000000110 : 01 : 000|~~Conflict~~ Compulsory|
|0x00000068|000000000000000000000000011 : 01 : 000|Conflict|
|0x000000DD|000000000000000000000000110 : 11 : 101|Compulsory|
|0x00000045|000000000000000000000000010 : 00 : 101|~~Capacity~~ Compulsory|
|0x00000004|000000000000000000000000000 : 00 : 100|Capacity|
|0x000000C8|000000000000000000000000110 : 01 : 000|~~Conflict~~ Capacity|

|Address |T/I/O|Hit,Miss,Replace|
|:---|:---|:---|
|0b0000 0100|0000 : 0 : 100|Compulsory|
|0b0000 0101|0000 : 0 : 101|Hit|
|0b0110 1000|0110 : 1 : 000|Compulsory|
|0b1100 1000|1100 : 1 : 000|Compulsory|
|0b0110 1000|0110 : 1 : 000|Hit|
|0b1101 1101|1101 : 1 : 101|~~Conflict~~ Compulsory|
|0b0100 0101|0100 : 0 : 101|~~Capacity~~ Compulsory|
|0b0000 0100|0000 : 0 : 100|Hit|
|0b1100 1000|1100 : 1 : 000|~~Conflict~~ Capacity|

## 5 Code Analysis
### 5.1
20
### 5.2
6 : 4 : 10
### 5.3
~~0.875~~    
0.5

> 注意**数组类型**为int，也就是说Line 1中相邻访问元素的间隔为128*4=512bytes，因此每个block包含两个元素，第一个元素为compulsory miss，第二个能hit
### 5.4
~~1~~   
0.5

> 数组的大小为$2^{15}bytes$，恰好为cache大小的两倍，第一轮循环结束后，cache中包含数组后一半的内容，而第二轮循环由从头开始，因此也是0.5