#include<stdio.h>
#include<omp.h>

int main(){
    int tid,thread_num;
    #pragma omp parallel private(tid)
    {
        tid = omp_get_thread_num();
        printf("hello world\n");
        if(tid == 0){
            thread_num = omp_get_num_threads();
            printf("Number of threads:%d\n",thread_num);
        }
    }
}