#include <data_conversion.h>

uint32_t float32_to_sign_magnitude_integer16(float number, int8_t offset)
{
  uint32_t  converted_number;
  //printf("Se recibe el número %f\n", number);
  uint32_t* float_raw_bits = (uint32_t *) &number;
  uint8_t   sign           = (*float_raw_bits) >> 31;
  uint8_t   exponent       = ((*float_raw_bits) & (0x7F800000)) >> 23;
  uint32_t  mantissa       = (((*float_raw_bits) & (0x007FFFFF)) | (0x00800000)) >> 8;
  
  uint8_t   exponent_range = (126+RES) + offset;
  //printf("El rango de exponentes se encuentra en: %u %u\n", exponent_range, exponent);
  uint8_t   shift_value    = exponent_range - exponent;
  //printf("Se debe shiftear %u\n", shift_value);

  
  if((exponent_range >= exponent) && (exponent >= (exponent_range-16)))
    {
      converted_number = mantissa >> shift_value;
      converted_number = (mantissa & (0x00000001 << shift_value-1)) ? converted_number+1 : converted_number;
    }
  else
    {
      converted_number = 0;
    }
  
  converted_number |= (sign << 16);
  
  return converted_number;
}

char* sign_magnitude_integer16_to_binary(uint32_t number)
{
  char integer_bits[16];
  char* p_integer_bits = integer_bits;
  number &= 0x0000FFFF;
  for(char i = 0; i < 16; i++)
    {
      integer_bits[i] = number % 2;
      number /= 2;
    }

  return p_integer_bits;
}

float sign_magnitude_integer16_to_float(uint32_t number, int8_t offset)
{
  float* converted_number;
  uint32_t converted_number_raw = 0;
  char* number_raw_bits;
  int8_t scientific_shift = 16;

  //printf("Se recibe el número entero %u con offset %d\n", number, offset);
  number_raw_bits = sign_magnitude_integer16_to_binary(number);
  for(char i = 15; (i >= 0) && (number_raw_bits[i] == 0); i--)
    {
      scientific_shift --;
    }
  //printf("El exponente queda como: %u\n", 126+scientific_shift+offset);
  //printf("El número es %08x\n", number);
  //printf("El scientific shift es %u\n", scientific_shift);
  //printf("Máscara: %08x\n", (number & (0x0000FFFF >> (17 - scientific_shift))));
  //printf("Máscara: %08x\n", (0x0000FFFF >> (17 - scientific_shift)));
  //printf("Mantissa %08x\n", (number & (0x0000FFFF >> (17 - scientific_shift))) << (24 - scientific_shift));
  converted_number_raw |= (((number & 0x00010000) << 15) | ((126+scientific_shift+offset) << 23) | (number & ((0x0000FFFF) >> (17-scientific_shift))) << (24 - scientific_shift));
  
  
  converted_number = (float *) &converted_number_raw;
  //printf("El número convertido es igual a %f\n", *converted_number);
  //printf("El número convertido es igual a %08x\n", *((uint32_t*) converted_number));
  //printf("El flotante quedaría como: %x\n", converted_number_raw);
  
  return *converted_number;
}

char* int32_to_binary(uint32_t number)
{
  if(number < 0)
    number *= -1;
  char integer_bits[32];
  char* p_integer_bits = integer_bits;
  for(char i = 0; i < 32; i++)
    {
      integer_bits[i] = number % 2;
      number /= 2;
    }

  return p_integer_bits;
}

float int32_to_float(uint32_t number, int8_t offset)
{
  float* converted_number;
  uint32_t converted_number_raw = 0;
  char* number_raw_bits;
  int8_t scientific_shift = 32;
  uint8_t adjust = 0;

  //printf("Se recibe el número entero %u con offset %d\n", number, offset);
  number_raw_bits = int32_to_binary(number);
  for(char i = 31; (i >= 0) && (number_raw_bits[i] == 0); i--)
    {
      scientific_shift --;
    }
  //printf("El exponente queda como: %u\n", 126+scientific_shift+offset);
  //printf("El número es %08x\n", number);
  //printf("El scientific shift es %u\n", scientific_shift);
  //printf("Máscara: %08x\n", (number << (33-scientific_shift)));
  //printf("Mantissa %08x\n", (number << (33-scientific_shift)) >> 9);
  //printf("exponent %08x\n", ((126+scientific_shift+offset) << 23));

  converted_number_raw |= ((number & 0x80000000) | ((126+scientific_shift+offset) << 23) | (number << (33-scientific_shift)) >> 9);
  
  
  converted_number = (float *) &converted_number_raw;
  //printf("El número convertido es igual a %f\n", *converted_number);
  //printf("El número convertido es igual a %08x\n", *((uint32_t*) converted_number));
  //printf("El flotante quedaría como: %x\n", converted_number_raw);
  
  return *converted_number;
}

uint32_t int32_to_sign_magnitude_integer16(int32_t number)
{
  if(number < 0)
  {
    number *= -1;
    number |= 0x00010000;
  }

  return number;
}

int32_t multiply_sign_magnitude_integer16(uint32_t number1, uint32_t number2)
{
  uint16_t number1_magnitude = number1 & (0x0000FFFF);
  uint16_t number2_magnitude = number2 & (0x0000FFFF);

  int32_t result = (number1_magnitude * number2_magnitude);
  if((number1 & (0x00010000)) ^ (number2 & (0x00010000)))
    result *= -1;

  return result;
}