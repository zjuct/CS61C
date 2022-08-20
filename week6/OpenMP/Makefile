CC=gcc
args=-fopenmp
lflag=-fopenmp

hello:hello.o
	$(CC) $(lflag) -o hello hello.o

hello.o:
	$(CC) -c $(args) hello.c

clean:
	rm -rf hello hello.o

