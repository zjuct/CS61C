#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns
    // 0 or 1)
    return (x >> n) & 0x1;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    // YOUR CODE HERE
    (*x) ^= (-v ^ *x) & (0x1 << n);
    /*
        case 1: *x的第n位为0，v为0
            (-v ^ *x)的第n位为0，与(*x)异或后仍为0
        case 2: *x的第n位为1，v为0
            (-v ^ *x)的第n位为1，与(*x)异或后为0
        case 3: *x的第n位为0，v为1
            (-v ^ *x)的第n位为0，与(*x)异或后为1
        case 4: *x的第n位为1，v为1
            (-v ^ *x)的第n位为0，与(*x)异或后为1
    */
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    // YOUR CODE HERE
    (*x) = (*x) ^ (0x1 << n);
}

