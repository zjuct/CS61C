# DISC 14 sol
## 1 Pre-Check
### 1.1
~~True. Spark is a library that implements MapReduce.~~

False. Spark is higher level, but you can also do basic mapreduce in Spark. 

### 1.2
False.

> PUE(Power Usage Effectiveness) = $\farc{数据中心总能耗}{IT设备总能耗}$

### 1.3
False. Hamming codes can correct 1 bit flop, and can detect 2 bits flop.
### 1.4
False. RAID 2 is the most reliable, since it copies the whole disk.

## 2 Hamming ECC
### 2.1
3
### 2.2
1,2,4
### 2.3
p1: 1,3,5,7   
p2: 2,3,6,7   
p4: 4,5,6,7
### 2.4
1000011
### 2.5
Add a bit 1 on the top of 1000011
### 2.6
1011
### 2.7
0100

## 3 RAID
### 3.1
||Configuration|Pro/Good for|Con/Bad for|
|:---:|:---:|:---:|:---:|
|RAID 0|Split data across all disks|faster accesses|No redundancy, cannot tolerate any failures|
|RAID 1|Each disk is fully duplicated onto its "mirror"|very high availability can be achieved|expensive|
|RAID 2|Add parity bits per bit|||
|RAID 3|Add parity bits per byte|||
|RAID 4|Add parity bits per block|||
|RAID 5|Interleaved parity|Enable independent writes, thus enable parallism||

## 4 MapReduce
### 4.1
```
map(CoinPair pair):
    emit(pair,1)

reduce(CoinPair pair, Iterable<int> count):
    total = 0
    for num in count:
        total += num
    emit(pair, total)
```

### 4.2
```
map(tuple<CoinPair, int> output):
    coin, num = output
    emit(coin.person, valueOfCoin(coin.coinType) * num)

reduce(String person, Iterable<float> count):
    total = 0
    for value in count: 
        total += value
    emit(person, value)
```

## 5 Spark
### 5.1
```python
coinData = sc.parallelize(coinPairs)
out1 = coinData.map(lambda (person,coinType) : ((person,coinType),1)).reduceByKey(lambda x,y : x+y)
out2 = out1.map(lambda (k1,k2) : (k1.person, valueOfCoin(k1.coinType) * k2)).reduce(lambda x,y : x+y)
```

### 5.2
```python
studentsData = sc.parallelize(students)
out = studentData.map(lambda (k1,k2) : (k1,(k2.studentGrade,1))).reduceByKey(lambda k1,k2 : (k1[0] + k2[0], k1[1] + k2[1])).map(lambda (k1,k2) : (k1,k2[0]/k2[1]))
```

## 6 Warehouse-Scale Computing
### 6.1
157.68 million
### 6.2
1.314 million
