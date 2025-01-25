#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

int main()
{
  float col_float = 0.7985496 << 24;
  uint32_t col_fixed = (uint32_t)(col_float);
  uint32_t row = 1256896;
  uint64_t result = row * col_fixed;
  uint32_t * p_result = (uint32_t)(&result);
  float f_result_fixed     = ((float) result) >> 24;
  float f_result_truncated = ((float) *(p_result+1)) >> 24;
  printf("El resultado de 64b es %f, mientras que el de 32b es %f \n", f_result_fixed, f_result_truncated);
}
