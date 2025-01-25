#include <data_conversion.h>

uint32_t decimal_float32_to_sign_magnitude_integer16(float number, int8_t range)
{
  uint32_t  converted_number;
  uint8_t     exponent_range;
  
  exponent_range = (126 + RES) + range;
  uint32_t* float_raw_bits = (uint32_t *) &number;
  uint8_t   sign           = (*float_raw_bits) >> 31;
  uint8_t   exponent       = ((*float_raw_bits) & (0x7F800000)) >> 23;
  uint32_t  mantissa       = (((*float_raw_bits) & (0x007FFFFF)) | (0x00800000)) >> 8;
  
  uint8_t shift_value = exponent_range - exponent;
  //uint8_t   shift_value    = ((exponent_range >= exponent) && (exponent >= (exponent_range-RES))) > 0 ? exponent_range-exponent : 0;

  if(exponent >= (exponent_range-RES))
    {
      converted_number = mantissa >> shift_value;
      //converted_number = (mantissa & (0x00000001 << shift_value-1)) ? converted_number+1 : converted_number;
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

float sign_magnitude_integer16_to_float(uint32_t number)
{
  float* converted_number;
  uint32_t converted_number_raw = 0;
  char* number_raw_bits;
  char scientific_shift = 0;

  number_raw_bits = sign_magnitude_integer16_to_binary(number);
  for(char i = 15; (i >= 0) && (number_raw_bits[i] == 0); i--)
    {
      scientific_shift ++;
    }

  converted_number_raw |= ((number & 0x00010000) << 15) | ((126-scientific_shift) << 23) | (number & (0x0000FFFF >> (1+scientific_shift))) << (23-(16-(scientific_shift+1)));

  
  converted_number = (float *) &converted_number_raw;
  //printf("El flotante quedaría como: %x\n", converted_number_raw);
  
  return *converted_number;
}

uint32_t decimal_float32_to_integer32(float number, int8_t range)
{
  uint32_t  converted_number;
  uint8_t     exponent_range;
  
  exponent_range = (126 + RES) + range;
  uint32_t* float_raw_bits = (uint32_t *) &number;
  uint8_t   sign           = (*float_raw_bits) >> 31;
  uint8_t   exponent       = ((*float_raw_bits) & (0x7F800000)) >> 23;
  uint32_t  mantissa       = (((*float_raw_bits) & (0x007FFFFF)) | (0x00800000)) >> 8;
  
  uint8_t shift_value = exponent_range - exponent;
  //uint8_t   shift_value    = ((exponent_range >= exponent) && (exponent >= (exponent_range-RES))) > 0 ? exponent_range-exponent : 0;
  printf("exponent %d\n", exponent);
  printf("exponent %d\n", shift_value);
  if(exponent >= (exponent_range-RES))
    {
      converted_number = mantissa >> shift_value;
      //converted_number = (mantissa & (0x00000001 << shift_value-1)) ? converted_number+1 : converted_number;
    }
  else
    {
      converted_number = 0;
    }
  converted_number = (sign) ? converted_number*-1 : converted_number;
  
  return converted_number;
}

char* integer32_to_binary(int32_t number)
{
  char integer_bits[32];
  char* p_integer_bits = integer_bits;
  for(char i = 0; i < 32; i++)
    {
      integer_bits[i] = number % 2;
      number /= 2;
    }

  return p_integer_bits;
}

float integer32_to_float(int32_t number, int8_t offset)
{
  float* converted_number;
  uint32_t converted_number_raw = 0;
  char* number_raw_bits;
  int8_t scientific_shift = 0;

  uint8_t sign = 0;
  uint8_t exponent = 0;
  uint32_t mantissa = 0;
  uint8_t shift_value = 0;

  if(number < 0)
  {
    sign = 1;
    printf("Holaaaaa\n");
    number *= -1;
  } 

  number_raw_bits = integer32_to_binary(number);
  for(char i = 31; (i >= 0) && (number_raw_bits[i] == 0); i--)
    {
      scientific_shift ++;
    }
  scientific_shift += 1;
  scientific_shift = (offset >= 0) ? scientific_shift : scientific_shift*-1;
  printf("scientific_shift: %d\n", scientific_shift);
  exponent = (127+scientific_shift);
  printf("exponent: %d\n", exponent);
  //if((offset > 32) || (offset < 0))
  //{
    /*
    if(offset > 32)
    {
      exponent = (127+scientific_shift);
    }
    */
    //mantissa = number >> 9;
  //}
  //else
  //{
  //shift_value = (scientific_shift >= offset) ? scientific_shift - offset : offset - scientific_shift; 
    if(scientific_shift < 0)
      scientific_shift *= -1;
    printf("Hexa number %08x\n", number);
    mantissa = (((uint32_t) number) <<  scientific_shift) >> 9;
    printf("Hexa number %08x\n", (((uint32_t) number) << 11));
    printf("Hexa number %08x\n", (((uint32_t) number) << 11) >> 8);
  //}

  converted_number_raw |= (sign << 31) | (exponent << 23) | mantissa;

  
  converted_number = (float *) &converted_number_raw;
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