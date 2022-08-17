# DISC 11 sol
## 1 Pre-Check
### 1.1
False. If a page table entry can not be found in the TLB, then it will look up in Page Table, if the valid bit of that page is 0, then a page fault has occurred.
### 1.2
False. The page number could be different, but the page size must be the same.

## 2 Addressing
### 2.1
1. Each process gets its own illusion of full memory to work with
2. Isolate the physical memory space of each process, and is also convenient for sharing physical memory space among processes.
3. Handle the problem of limited physical memory

### 2.2
All of the valid bit of the entry in TLB should be set to false.

## 3 VM Access Patterns
### 3.1
|VPN|PPN|Valid|Dirty|LRU|
|:---:|:---:|:---:|:---:|:---:|
|0x01|0x11|1|1|5|
|0x13|0x17|1|1|3|
|0x10|0x13|1|1|6|
|0x20|0x12|1|1|1|
|0x23|0x18|1|1|2|
|0x11|0x14|1|0|4|
|0xac|0x15|1|1|7|
|0x34|0x19|1|1|0|

> LRU规则，每将一个LRU bits置为0时，将所有小于其的LRU加一（大于它的不用加）

