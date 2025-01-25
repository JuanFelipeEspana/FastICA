#ifndef ARRAY_UTILITIES

#define ARRAY_UTILITIES

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>


uint32_t string_size(char *string);
void array_copy(void *array_to_copy_from, void *array_to_store, uint32_t size, uint16_t data_bytes, uint32_t offset);
void array_fill_zeros(void *array, uint32_t size, uint16_t data_bytes);
int32_t mypow(int32_t base, uint32_t exp);
int32_t random_number_generate(uint32_t limit);

#endif