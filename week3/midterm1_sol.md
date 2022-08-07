# MidTerm 1<br>
## 1 A Generic C Question<br>
(a)<br>
```C
typedef struct{
    union{
        char char_val;
        uint16_t uint16_val;
        uint32_t uint32_val; 
    }value;
    GenericLink* next; 
} GenericLink;
```

(b)<br>
8

(c)<br>
i.<br>
```C
GenericLink* store_char(char c){
    GenericLink* node = (GenericLink*)malloc(sizeof(GenericLink));
    node->value.char_val = c;
    node->next = NULL;
    return node;
}
```
ii.<br>
```C
GenericLink* store_string(char* str){
    GenericLink* first = NULL;
    GenericLink* p = first;
    for(int i = 0;str[i]!='\0';i++){
        GenericLink* node = store_char(str[i]);
        if(!first){
            first = node;
            p = first;
        }
        else{
            p->next = node;
            p = p->next;
        }
    }
    return first;
}
```

## 2 Doubly Linked Trouble<br>
(a)<br>
i. Stack<br>
ii. Stack<br>
iii. Code<br>
iv. Static<br>
v. Stack<br>
vi. Heap<br>
vii. Heap

(b)<br>
63

(c)<br>
False

## 3 RISC-V<br>
(a)<br>
i. $-2^{13}$<br>
ii. $2^{13}-1$

(b)<br>
i. ~~lw t0, 0(a0)~~ lb t0,0(a0) 字符串<br>
ii. addi a0, a0, 1 元素类型<br>
iii. addi sp,sp,-4<br>
iv. sw ra,0(sp)<br>
v. lw ra,0(sp)<br>
vi. addi sp,sp,4<br>
vii. addi a0,a0,1<br>
viii. mv a0,0

(c)<br>
i. xori a0,a0,-1<br>
ii. addi a0,a0,1

(d)<br>
i. 0XABCDDBBC<br>
ii. ~~0X000000AB~~  0xFFFFFFAB 注意lb,lh都有sign-extension

## 4 CALL<br>
(a) False

(b)<br>
i.A loop<br>
i.B 0x14<br>
ii.A n<br>
ii.B 0x24<br>
iii.A end<br>
iii.B 0x2c<br>
iv.A square<br>
iv.B 0x30

(c) False

(d) ~~0x29000ef~~ 0x014000ef

(e) Assembler

(f) Linker, Compiler, Assembler

(g) jal ra, printf

> 读题不仔细，是first pass,还有beq t0,t1,end 和jal ra,square

## 5 Number Fun<br>
(a)<br>
i. Overflow<br>
ii. Correct<br>
iii. Overflow

(b)<br>
i.A True<br>
i.B False

ii True

(c)<br>
i. Sign and Magnitude, One's Complement

> 还有Floating Point,IEEE 754里面有两个0

ii. Two's Complement, One's Complement, Floating Point, Sign and Magnitude

> 还有Biased,因为bias是可以任意取的

(d) 1

(e)<br>
i. 60<br>
ii. 0b00111100<br>
iii. 0330<br>
iv. 074<br>
v. ob10111011

(f)<br>
i. 0<br>
ii. 128

## 6 Don't Float Away<br>

(a)<br> 
i. 0.234375<br>
ii. 31<br>
iii. 15

(b)<br>
i. 0.015625<br>
ii. 0x01

(c)<br>
i. 3.125<br>
ii. 0x49
