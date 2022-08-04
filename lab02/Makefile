UNAME_S := $(shell uname -s)	# 调用shell命令，uname -s 获取内核名称
CC=gcc		# 指定编译器
LD=gcc
CFLAGS=-ggdb -Wall -std=c99		# 指定通用的编译选项
LDFLAGS=

# 根据操作系统内核，选择不同的valgrind配置
# Darwin就是IOS
ifeq ($(UNAME_S), Darwin)
    MEMCHECK=valgrind --tool=memcheck --leak-check=full --track-origins=yes --dsymutil=yes --suppressions=osx_vector.supp
endif
# --tool指定valgrind工具，默认就是memcheck
# --leak-check=full检查内存泄漏
# --track-origins=yes将寻找uninitialised value error的源头
ifeq ($(UNAME_S), Linux)
    MEMCHECK=valgrind --tool=memcheck --leak-check=full --track-origins=yes
endif

BIT_OPS_OBJS = bit_ops.o test_bit_ops.o		# bit_ops相关的.o文件
BIT_OPS_PROG = bit_ops						# bit_ops程序名

LFSR_OBJS = lfsr.o test_lfsr.o				# lfsr相关的.o文件
LFSR_PROG = lfsr							# lfsr程序名

VECTOR_OBJS=vector.o vector_test.o			# vector相关的.o文件
VECTOR_PROG=vector_test						# vector程序名

BINARIES=$(VECTOR_PROG) $(BIT_OPS_PROG) $(LFSR_PROG)	# 二进制文件集合

# 伪指令，即产生所有文件
all: $(BINARIES)

#即 gcc -o bit_ops相关文件
$(BIT_OPS_PROG): $(BIT_OPS_OBJS)			
	$(CC) $(CFLAGS) -g -o $(BIT_OPS_PROG) $(BIT_OPS_OBJS) $(LDFLAGS)

#即 gcc -o lfsr相关文件
$(LFSR_PROG): $(LFSR_OBJS)					
	$(CC) $(CFLAGS) -g -o $(LFSR_PROG) $(LFSR_OBJS) $(LDFLAGS)

$(VECTOR_PROG): $(VECTOR_OBJS)
	$(CC) $(CFLAG) -g -o $(VECTOR_PROG) $(VECTOR_OBJS) $(LDFLAGS)

# 指定.c文件的依赖
lfsr.c: lfsr.h			
test_lfsr.c: lfsr.h

bit_ops.c: bit_ops.h
test_bit_ops.c: bit_ops.h

# $< 为自动变量，代表第一个依赖，此处即.o文件对应的.c文件
# 自动推断，即 gcc -c xxx.c
.c.o:					
	$(CC) -c $(CFLAGS) $<		

# 伪指令，使用valgrind进行内存检查
vector-memcheck: $(VECTOR_PROG)		
	$(MEMCHECK) ./$(VECTOR_PROG)

# 伪指令，进行清除工作
clean:
	-rm -rf core *.o *~ "#"*"#" Makefile.bak $(BINARIES) *.dSYM

vector.c: vector.h
vector_test.c: vector.h
