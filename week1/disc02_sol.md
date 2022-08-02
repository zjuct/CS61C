# DISC 02 sol

## 1 Pre-Check 

### 1.1

True

### 1.2

The pointer is a variable, which holds an address. Both point to a memory location. Can substitude the other when passed into a function.

> An array acts like a pointer to the first element in the allocated memory for that array

### 1.3

~~Both will cause a complier error.~~

It will treat the variable's underlying bits as if they were a pointer and attempt to access data there. C will allow you to do almost anything you want, though if you attempt to access an "illegal" memory address.

If you free a variable that either has been freed before or was not malloced/calloced/realloced, it will cause a "invalid free" error.

### 1.4

When you want to allocate a piece of memory that is permenent. The stack grows from larger address to lower. The heap grows in the oppsite side.

If you need to keep access to data over several function calls, use the heap. If you’re dealing with a large piece of data, passing around a pointer to something on the heap is more efficient and a better practice than passing around the data itself. (Think: carrying a library around vs knowing the address TO the library). Heaps grow up and stacks grow down, meeting when working memory is full.

## 2 C

### 2.1

pp is a pointer to int*, which holds the address 0xF9320904.<br>
*pp == 0xF93209AC<br>
**pp == 0x2A

### 2.2

(a) Calculate the sum of elements in arr.<br>
(b) Return the inverse of the number of 0s in **the first N elements of** arr.<br> 
(c) Do nothing, because C passes by value.<br>
(d) ~~\~^~~ ==

## 3 Programming with Pointers 

### 3.1

(a)
```c
void swap(int* a,int* b){
    int tmp = *a;
    *a = *b;
    *b = tmp;
}
```
(b)
```c
int mystrlen(char* str){
    int count = 0;
    while(*str != '\0'){
        count++;
        str++;
    }
    return count;
}
//better solution
int mystrlen(char* str){
    int count = 0;
    while(*str++){
        count++;
    }
    return count;
}
```

### 3.2

```c
//(a)
int sum(int* summands,size_t size){
    int sum = 0;
    for(int i = 0;i< size; i++){
        sum += *(summands+i);
    }
    return sum;
}
//(b)
//这个程序的bug在于如果原先的值为0xFF,自增会使结束符提前
void increment(char* string){
    for(int i = 0;string[i] != '\0';i++){
        (*(string + i))++;
    }
}
//(c)
void copy(char* src, char* dst){
    while(*dst++ = *src++);
}
//(d)
void cs61c(char* src, size_t length){
    char *srcptr,*replaceptr;
    char replacement[16] = "61C is awesome";
    srcptr = src;
    replaceptr = replacement;
    if(length >= 16){
        for(int i = 0;i<16;i++){
            *srcptr++ = *replaceptr++;
        }
    }
}
```

## 4 Memory Management

### 4.1

(a) static<br>
(b) stack<br>
(c) static<br>
(d) static,**code, or stack**<br>
> 代码中的立即数可以是constant，如x = x + 1

(e) code<br>
(f) heap<br>
(g) static **or stack*<br>
> char* str = "string" 存放在static<br>
> char[] str = "string" 存放在stack

### 4.2
```c
int* arr = (int*)malloc(sizeof(int)*k); //a
char* str = (char*)malloc(sizeof(char)*(p+1));  //b
int* mat = (int*)calloc(n*m,sizeof(int));   //c
```

### 4.3

buffer is an array of char*, whose length is 64, rather than an array of char. But the argument of gets is char*, so it will cause compiled error.


If the user input contains more than 63 characters, then the input will override other parts of the memory! (You will learn more about this and how it can be used to maliciously exploit programs in CS 161.)
Note that it’s perfectly acceptable in C to create an array on the stack. It’s often discouraged (mostly because people often forget the array was initialized on the stack and accidentally return a pointer to it), but it’s not an issue itself.

### 4.4

```c
void prepend(struct ll_node** lst, int value){
    struct ll_node* node = (struct ll_node*)malloc(sizeof(struct ll_node));
    node->first = value;
    node->rest = *lst;
    *lst = node;
}
```

### 4.5

```c
void free_ll(struct ll_node** lst){
    struct ll_node* p = *lst;
    while(p){
        struct ll_node* tmp = p;
        p = p->rest;
        free(tmp);
    }
    (*lst) = NULL;
}
//递归版本
void free_ll(struct ll_node** lst){
    if(*lst){
        free_ll(&((*lst)->rest));
        free(*lst);
    }
    *lst = NULL;
}
```

