#include<stdio.h>
#include<omp.h>
#include<stdlib.h>
#include<time.h>

int* matrix_mul1(int* m1,int* m2,int size){
    int* c = (int*)malloc(sizeof(int)*size*size);
    for(int i = 0;i<size;i++){
        for(int j = 0;j<size;j++){
            for(int k = 0;k<size;k++){
                c[i*size+j] += m1[i*size+k] * m2[k*size+j];
            }
        }
    }
    return c;
}

int* matrix_mul2(int* m1,int* m2,int size){
    int* c = (int*)malloc(sizeof(int)*size*size);
    for(int k = 0;k<size;k++){
        for(int j = 0;j<size;j++){
            for(int i = 0;i<size;i++){
                c[i*size+j] += m1[i*size+k] * m2[k*size+j];
            }
        }
    }
    return c;
}

int* matrix_mul3(int* m1,int* m2,int size){
    int* c = (int*)malloc(sizeof(int)*size*size);
    #pragma omp parallel for
        for(int i = 0;i<size;i++){
            for(int j = 0;j<size;j++){
                for(int k = 0;k<size;k++){
                    c[i*size+j] += m1[i*size+k] * m2[k*size+j];
                }
            }
        }
    return c;
}

#define MAX_SIZE 1000

int main(){
    srand((unsigned int)time(NULL));

    int* m1 = (int*)malloc(sizeof(int)*MAX_SIZE*MAX_SIZE);
    int* m2 = (int*)malloc(sizeof(int)*MAX_SIZE*MAX_SIZE);
    for(int i = 0;i<MAX_SIZE;i++){
        for(int j = 0;j<MAX_SIZE;j++){
            m1[i*MAX_SIZE+j] = rand();
            m2[i*MAX_SIZE+j] = rand();
        }
    }
    clock_t time1 = clock();
    int* c1 = matrix_mul1(m1,m2,MAX_SIZE);
    clock_t time2 = clock();
    int* c2 = matrix_mul2(m1,m2,MAX_SIZE);
    clock_t time3 = clock();
    int* c3 = matrix_mul3(m1,m2,MAX_SIZE);
    clock_t time4 = clock();

    printf("%d\n",(int)(time2 - time1));
    printf("%d\n",(int)(time3 - time2));
    printf("%d\n",(int)(time4 - time3));

    for(int i = 0;i<MAX_SIZE;i++){
        for(int j = 0;j<MAX_SIZE;j++){
            if(c1[i*MAX_SIZE+j] != c2[i*MAX_SIZE+j] || c1[i*MAX_SIZE+j] != c3[i*MAX_SIZE+j]){
                printf("Not equal\n");
                free(c1);
                free(c2);
                free(c3);
                free(m1);
                free(m2);
                exit(1);
            }
        }
    }
    printf("equal\n");
    free(c1);
    free(c2);
    free(c3);
    free(m1);
    free(m2);
}