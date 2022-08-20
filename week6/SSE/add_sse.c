#include<emmintrin.h>
#include<stdio.h>
#include<time.h>

void add_SSE(int size, int* first_array, int* second_array){
    for(int i = 0; i<size;i+=4){
        __m128i first_values = _mm_loadu_si128((__m128i*) &first_array[i]);
        __m128i second_values = _mm_loadu_si128((__m128i*) &second_array[i]);
        first_values = _mm_add_epi32(first_values,second_values);
        _mm_storeu_si128((__m128i*) &first_array[i],first_values);
    }
}

void add(int size,int* first,int* second){
    for(int i = 0;i<size;i++){
        first[i]+=second[i];
    }
}

void print_array(int* arr,int size){
    for(int i = 0;i<size;i++){
        printf("%d\n",arr[i]);
    }
}

#define SIZE 100

int main(){
    int arr1[SIZE];
    int arr2[SIZE];
    for(int i = 0;i<SIZE;i++){
        arr1[i] = i;
        arr2[i] = 2*i;
    }
    clock_t clock1 = clock();
    for(int i = 0;i<1000000;i++){
        add_SSE(SIZE,arr1,arr2);
    }
    clock_t clock2 = clock();
    printf("%d\n",clock2 - clock1);
    clock1 = clock();
    for(int i = 0;i<1000000;i++){
        add(SIZE,arr1,arr2);
    }
    clock2 = clock();
    printf("%d\n",clock2 - clock1);

    //print_array(arr1,4);
}