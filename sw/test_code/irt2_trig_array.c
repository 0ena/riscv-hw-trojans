/*  irt2_trig_array.c 
 *  This process accepts as input a number # of elements and the starting address of an array in the kernel 
 *  and performs overwriting of the contents of # array elements.
 **/

// Author: Athanasios Moschos
// Date: 12/02/2023

#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main(int argc, char *argv[] ){

  char *temp;
  uint64_t num_loop = 0;
  uint64_t ptr_tmp = 0;
  int i;
  uint64_t *ptr;

  temp = argv[1];
  num_loop = atoi(temp);

  temp = argv[2];
  ptr_tmp = strtoul(temp, NULL, 16);
  ptr = (void *) ptr_tmp;
  
  // Change the value stored inside the address.
  for (i=0; i < num_loop; i++) {
    *ptr = 0xCBBBBBBBAAAAAAAD;
    ptr = ptr+1;
  }

  return 0;
}
