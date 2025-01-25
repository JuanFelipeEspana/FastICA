#include <array_utilities.h>

uint32_t string_size(char* string)
{
  uint32_t length = 0;
  while(*(string+length) != '\0')
    {
      length++;
    }
  return length;
}

void array_copy(void* array_to_copy_from, void* array_to_store, uint32_t size, uint16_t data_bytes)
{
  uint8_t* uint8_array_to_copy_from = (uint8_t* ) array_to_copy_from;
  uint8_t* uint8_array_to_store     = (uint8_t* )     array_to_store;
  uint8_t string_end = 0;
  
  for(uint64_t i = 0; i < size*data_bytes; i++)
    { 
      *(uint8_array_to_store+i) = *(uint8_array_to_copy_from+i);
    }
}

void array_fill_zeros(void* array, uint32_t size, uint16_t data_bytes)
{
  uint8_t* uint8_array = (uint8_t* ) array;
  for(uint32_t i = 0; i < size*data_bytes; i++)
    {
      *(uint8_array+i) = 0;
    }
}
  
int32_t mypow(int32_t base, uint32_t exp)
{
  int32_t power = 1;
  for(uint32_t i = 0; i < exp; i++)
    {
      power *= base;
    }
  return power;
}
