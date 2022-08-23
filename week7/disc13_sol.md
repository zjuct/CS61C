# DISC 13 sol
## 1 Pre-Check
### 1.1
False. Each thread has its own cache, which can lead to cache-incoherence.
### 1.2
~~True. If there are two or more instructions, then they might be interrupted when executing.~~

> False, load-reserve, store-conditional allows uninterrupted execution across multiple instructions.

### 1.3
False. Sometimes increse the number of threads won't speed up the program, and may even make the program slower.

## 2 Coherency and Atomics
### 2.1
For lr and sc, after lr, other threads cannot write to the location marked reserve, hence the value loaded from memory will be unchanged between lr and sc. For amoswap, it does load and store in one single CPU cycle, hence the operation is atomic and uninterruptable.
### 2.2
```
sw t0,0(a1)
jal get_thread_num
lr.w t1,(a1)
bne a0,t1, Check
sc.w t1,t0,(a1)
bne t1,x0,Check
```

## 3 Thread-Level Parallelism
### 3.1
(a) slower than serial   
(b) always incorrect   
(c) faster than serial  
### 3.2
~~The parallel code runs slower than serial~~

> False sharing arises because different threads can modify elements located in the same memory block simultaneously.

### 3.3
(a) product is a shared variable, which will cause data race.   
(b)    
```C
double fast_product(double* arr,int n){
    double product = 1;
    #pragma omp parallel for
    for(int i = 0;i<n;i++){
        #pragma omp critical
        product *= arr[i];
    }
    return product;
}
```
(c)    
```C
double fast_product(double* arr,int n){
    double product = 1;
    #pragma omp parallel for reduction(* : product)
    for(int i = 0;i<n;i++){
        product *= arr[i];
    }
    return product;
}
```

## 4 Amdahl's Law
### 4.1
24.43
### 4.2
(a) h    
(b) 2.11