#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

uint16_t get_bit(uint16_t x,
                 uint16_t n) {
    return (x >> n) & 0x1;
}

void set_bit(uint16_t * x,
             uint16_t n,
             uint16_t v) {
    // YOUR CODE HERE
    (*x) ^= (-v ^ *x) & (0x1 << n);
}

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t d0 = get_bit(*reg,0);
    uint16_t d2 = get_bit(*reg,2);
    uint16_t d3 = get_bit(*reg,3);
    uint16_t d5 = get_bit(*reg,5);
    uint16_t x = d0^d2^d3^d5;
    (*reg) >>= 1;
    set_bit(reg,15,x);
}

