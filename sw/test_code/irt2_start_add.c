/*  irt2_start_add.c 
 *  This process enables the IRT-2 trojan by exercising the ALU adder with specific operand values. 
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

  // Trigger the Trojan
  // operand_a = 0xfffffffe00000000
  // operand_b = 0xffffffff80000000
  asm ( "addi a5,zero,1\n\t" \
      "sll a5,a5,0x20\n\t" \
      "lui t0,0xfffff\n\t" \
      "sll t0,t0,0x14\n\t" \
      "xor t0,t0,a5\n\t" \
      "lui t1,0xfffff\n\t" \
      "sll t1,t1,0x13\n\t" \
      "add a6, t0, t1\n\t" \
    );

  return 0;
}
