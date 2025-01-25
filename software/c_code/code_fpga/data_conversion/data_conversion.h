#ifndef DATA_CONVERSION

#define DATA_CONVERSION

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

#define RES       16

uint32_t float32_to_sign_magnitude_integer16(float number, int8_t offset);
uint8_t float32_get_exponent(float number);
char* sign_magnitude_integer16_to_binary(uint32_t number);
float sign_magnitude_integer16_to_float(uint32_t number, int8_t offset);
char* int32_to_binary(uint32_t number);
float int32_to_float(uint32_t number, int8_t offset);
uint32_t int32_to_sign_magnitude_integer16(int32_t number);
int32_t multiply_sign_magnitude_integer16(uint32_t number1, uint32_t number2);

#endif