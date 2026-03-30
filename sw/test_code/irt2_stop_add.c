/*  irt2_stop_add.c 
 *  This process disables the IRT-2 trojan, by exercising the ALU adder with specific operand values.
 **/

// Author: Athanasios Moschos
// Date: 12/02/2023

#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main(){

  asm ( "addi a5,zero,1\n\t" \
      "sll a5,a5,0x20\n\t" \
      "lui t0,0xfffff\n\t" \
      "sll t0,t0,0x14\n\t" \
      "xor t0,t0,a5\n\t" \
      "lui t1,0xfffff\n\t" \
      "sll t1,t1,0x13\n\t" \
      "add a6, t1, t0\n\t" \
    );

  return 0;
}
