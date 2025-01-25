#ifndef MATRIX

#define MATRIX

#include <time.h>
#include <array_utilities.h>
#include <data_conversion.h>

typedef struct int32_matrix
{
    uint32_t      rows;
    uint32_t      cols;
    uint8_t     vector;
    int32_t*   address;
} int32_matrix;

typedef struct float_matrix
{
    uint32_t      rows;
    uint32_t      cols;
    uint8_t     vector;
    float*     address;
} float_matrix;

void int32_matrix_create(int32_matrix* matrix, uint32_t rows, uint32_t cols);
void int32_matrix_fill_random(int32_matrix* matrix, uint32_t limit);
void float_matrix_to_int32_matrix(float_matrix* float_matrix, int32_matrix* int32_matrix, int8_t offset);
void int32_matrix_to_sign_magnitude_integer16(int32_matrix* matrix_to_parse, int32_matrix* matrix_to_store);
void int32_matrix_multiply(int32_matrix* matrix1, int32_matrix* matrix2, int32_matrix* result);
void int32_matrix_multiply_custom(int32_matrix* matrix1, int32_matrix* matrix2, int32_matrix* result);
void int32_matrix_print(int32_matrix* matrix, uint8_t print_type);
void int32_matrix_free(int32_matrix* matrix);
void float_matrix_create(float_matrix* matrix, uint32_t rows, uint32_t cols);
void float_matrix_fill_random(float_matrix* matrix, uint32_t limit, uint8_t decimal);
void int32_matrix_to_float_matrix(int32_matrix* int32_matrix, float_matrix* float_matrix, int8_t offset);
void int32_matrix_full_to_float_matrix(int32_matrix* int32_matrix, float_matrix* float_matrix, int8_t offset);
void float_matrix_multiply(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result);
void float_matrix_multiply_int32_matrix(float_matrix* matrix1, int32_matrix* matrix2, float_matrix* result);
void float_matrix_print(float_matrix* matrix);
void float_matrix_free(float_matrix* matrix);
int32_t random_number_generate(uint32_t limit);

#endif