# Cache

### 存储层级(memory hierarchy)

Goal: Create the illusion of memory being almost as fast as fastest memory and almost as large as biggest memory of the hierarchy

<img src=img\1.png>

- 各层级之间存储的内容是包含关系，即Level 1存储的内容是Level 2的子集
- 离处理器越近的层级，其速度越快，但容量更小，且更贵；越下层的层级，其容量越大、越便宜，但速度越慢

## Cache

在存储层级中，离处理器最近的几个Level被称为cache，其由Static RAM实现

### 基本概念

Cache以**block**为单位进行存储，block的具体大小没有规定，所谓block，就是相邻多个bytes的集合

- offset: 由于block中含有多个byte，而大多时候（如RISC-V中的load）都只需要访问其中的某一byte或word，因此需要offset来唯一标志block中的某一byte
- index: 用于映射类的cache，类似hashCode，使用某种方式来将内存地址唯一映射到cache的某一位置处
- tag: 由于内存的大小比cache要大，因此必定会出现多个block映射到同一index的情况，此时就需要tag来唯一标识这些block作为区分
- valid bit: cache中存放的内容不一定是有效的，比如cache刚通电被初始化时，cache中存放的为垃圾值，此时就需要valid bit来标识某一位置的block是否有效
- Hit rate(HR): 随机发生内存读写时，cache命中的概率
- Miss rate(MR): 1 - Hit rate
- Hit time: Time to access cache(including Tag comparison)
- Miss penalty(MP): Time to replace a block in the cache from a lower level in the memory hierarchy

<img src=img\2.png>

> offset的大小由block的大小唯一确定，$offset = \log_{2}{block\ size}$ ，比如一个block含有8个byte，那么offset为3，即内存地址的最低3位被用作offset，来标识同一block中的不同byte

<img src=img\3.png>

> 对于最简单的Fully Associative Cache(不进行映射)，除了offset外，剩下的位就作为tag，即内存中有$2^{k}$个block，那么tag就要有$k$位

---

### Fully Associative Cache<br>
- Each memory block can map **anywhere** in the cache
- 在fully associative cache中查找的步骤
  1. Look at ALL cache slots in the sequence
  2. If valid bit is 0, then ignore
  3. If valid bit is 1 and Tag matches, then return that data

<img src=img\5.png>

**Reading Policies**<br>
当从cache中读取时，有以下两种情况

- Cache hit: Cache中含有待读取的元素，因此将该元素返回
- Cache miss: Cache中不含有待读取的元素，因此从上一层memory hierarchy中获取该包含该地址的block，再将待读取元素返回

**Block Replacement Policies**<br>
指的是当要从上一层级读取block，但此时FA Cache已满时，如何进行替换的策略

- Random Replacement
- Least Recently Used(LRU) : 使用额外的management bits来记录cache中每一block的访问情况，替换时替换将最早访问的

<img src=img\4.png>

**Writing Policies**<br>
与read相同，write同样有hit和miss两种情况

- Write hits
  1. Write-Through Policy(写穿透): 任意时刻将数据写入cache时，同时将数据写入内存，这使得cache和内存在任意时刻都是相同的(consistent)。由于这种做法相对较慢，通常引入Write Buffer，使得内存的更新能够与处理器的运行并行
  2. Write-Back Policy(写返回): 将数据写入cache中时，并不同时写回内存，而只有当该block被替换回内存时，才同步修改。使用额外的Dirty bit来标志某一block是否经过了修改
- Write misses
  1. Write allocate: 当出现write miss时，直接修改内存中的数据，同时将被修改的block读入cache，一般与Write-back同时使用
  2. No write allocate: 当出现write miss时，直接修改内存中的数据，但不将block读入cache，一般与Write-through同时使用

---

### Direct Mapped Cache<br>
- 每个memory block映射到cache中唯一的slot
  - 使用hash function来确定每一block映射到哪个slot
- 与fully associative cache相比
  - 访问时，只需要查找一个block，更快
  - 不需要replacement policy
  - 但空间利用率变小，会出现空槽

对于任意一个内存地址，其被分为三个部分
- Index field: 决定要到cache中的哪个槽来查找
- Offset field: 找到对应的block后，待访问元素位于block的哪个位置
- Tag field: 除去Index field和Offset field，剩下的就是Tag field，用来区分映射到同一slot的所有不同block

最简单的映射函数就是直接对block地址取模

$$\begin{equation*}
  Index = Addr\ of\ block\ \%\ Cache\ size
\end{equation*}$$

<img src=img\6.png>

- 最低位为offset bits，长度为$\log_{2}{block size(bytes)}$
- 中间为Index，长度为$\log_{2}{\frac{cache\ size(byte)}{block\ size(byte)}}$
- 剩下来的所有位作为Tag
- 实际上，对于cache中的每个block，还要存储1位的valid bit和1位的dirty bit(如果使用write-back)

---

### Set Associative Cache<br>
DM和FA的结合

- N-way set-associative: 将cache等分为多个sets，每个set的大小为$N$，即每个set存放$N$个block
- 对于内存中的每个block地址，将其唯一映射到某一set，然后其在set内部的存储位置使用FA策略，即随意存储
- N 被称为**associativity**
- 需要Replacement policy，但替换只在set内部进行

内存地址划分

- Offset: 不变，仍为$\log_{2}{block\ size(byte)}$
- Index: 由于映射到set而不是某一确定slot，因此$Index = \log_{2}{\frac{cache\ size(byte)}{N * block\ size(byte)}}$
  - Fully associative是set = 1的特殊情况
  - Direct-mapped 是N = 1的特殊情况
- Tag: 剩下来的就是Tag

### Average Memory Access Time
Average Memory Access Time(AMAT)是一种评估内存访问效率的标准

> AMAT = Hit time + Miss rate * Miss penalty

- Hit time: time to check if the data we're looking for is in the cache(每次内存访问的固定花费)
- Miss rate: percentage of accesses of a program that are not in the cache when we look for them
- Miss penalty: cost incurred by going to memory

### 3C's Miss
Miss分为三种类型

- Compulsory Miss: The First access to block, which is impossible to avoid——对某一block的第一次访问一定是compulsory miss
- Capacity Miss: 将完整的内存访问序列作用于FA cache(采用LRU替换方式)，如果FA cache也会miss，那么就是capacity miss
- Conflict Miss: 判断方式与capacity相同，如果FA cache为hit，则为conflict miss

<img src=img\7.png>

### Multilevel Cache
可以通过使用多层Cache的方式，来改良Cache效果

- 一般使用2~3层Cache
- 第一层cache（离CPU最近）重点在于降低Hit time。因为降低Hit time能够提升时钟频率，因此第一层cache往往较小，associativity也较小
- 第二层和第三层cache重点在于降低Miss rate，即将第一层cache的miss在这两层就拦截下来，因此二三层cache往往block size较大，associativity也较大



