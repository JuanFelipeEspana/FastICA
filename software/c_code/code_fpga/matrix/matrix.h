#ifndef MATRIX

#define MATRIX

#include <time.h>
#include <array_utilities.h>
#include <data_conversion.h>
#include <math.h>
#include <lapacke.h>

typedef struct int32_matrix
{
    uint32_t      rows;
    uint32_t      cols;
    uint8_t     vector;
    int32_t*   address;
} int32_matrix;

typedef struct float_matrix
{
    uint32_t        rows;
    uint32_t        cols;
    uint8_t   row_vector;
    uint8_t   col_vector;
    float*       address;
    uint8_t max_exponent;
    uint8_t min_exponent;
} float_matrix;

typedef struct double_matrix
{
    uint32_t       rows;
    uint32_t       cols;
    uint8_t  row_vector;
    uint8_t  col_vector;
    double*      address;
} double_matrix;

void int32_matrix_create(int32_matrix* matrix, uint32_t rows, uint32_t cols);
void int32_matrix_fill_random(int32_matrix* matrix, uint32_t limit);
void float_matrix_to_int32_matrix(float_matrix* float_matrix, int32_matrix* int32_matrix, int8_t offset);
void int32_matrix_to_sign_magnitude_integer16(int32_matrix* matrix_to_parse, int32_matrix* matrix_to_store);
void int32_matrix_multiply(int32_matrix* matrix1, int32_matrix* matrix2, int32_matrix* result);
void int32_matrix_print(int32_matrix* matrix, uint8_t print_type);
void int32_matrix_free(int32_matrix* matrix);


void float_matrix_create(float_matrix* matrix, uint32_t rows, uint32_t cols);
void float_matrix_find_range(float_matrix* matrix);
void float_matrix_fill_random(float_matrix* matrix, uint32_t limit);
void float_matrix_fill_zeros(float_matrix* matrix);
void int32_matrix_to_float_matrix(int32_matrix* int32_matrix, float_matrix* float_matrix, int8_t offset);
void int32_matrix_full_to_float_matrix(int32_matrix* int32_matrix, float_matrix* float_matrix, int8_t offset);
float float_matrix_multiply(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result);
void float_matrix_multiply_int32_matrix(float_matrix* matrix1, int32_matrix* matrix2, float_matrix* result);

void float_matrix_multiply_scalar(float_matrix* matrix, float scalar, float_matrix* result_matrix);
void float_matrix_mean_cols(float_matrix* data_matrix, float_matrix* mean_vector);
void float_matrix_mean_rows(float_matrix* data_matrix, float_matrix* mean_vector);
void float_matrix_minus_vector_col(float_matrix* data_matrix, float_matrix* vector, float_matrix* result_matrix);
void float_matrix_minus_vector_row(float_matrix* data_matrix, float_matrix* vector, float_matrix* result_matrix);
void float_matrix_transpose(float_matrix* matrix, float_matrix* matrix_transposed);
void float_matrix_copy_row(float_matrix* matrix, uint32_t row, float_matrix* copied_row);
void float_matrix_copy_col(float_matrix* matrix, uint32_t col, float_matrix* copied_col);
void float_matrix_paste_row(float_matrix* vector, uint32_t row, float_matrix* matrix);
void float_matrix_paste_col(float_matrix* vector, uint32_t col, float_matrix* matrix);


void float_matrix_power_minus_one(float_matrix* data_matrix, float_matrix* result_matrix);
void float_matrix_absolute_value(float_matrix* original_matrix, float_matrix* abs_matrix);
void float_matrix_sum(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result_matrix);
void float_matrix_minus(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result_matrix);
void float_matrix_substract(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result_matrix);
void float_matrix_vector_normalize(float_matrix* matrix, float_matrix* result_matrix);
void float_matrix_svd_decomposition_lapacke(float_matrix* matrix, float_matrix* u, float_matrix* sigma, float_matrix* v);




void float_matrix_print(float_matrix* matrix, char separator);
void float_matrix_print_file(float_matrix* matrix, char separator, FILE* file_to_write);
void float_matrix_destroy(float_matrix* matrix);

void double_matrix_create(double_matrix* matrix, uint32_t rows, uint32_t cols);
void float_matrix_to_double_matrix(float_matrix* matrix_float, double_matrix* matrix_double);
void double_matrix_to_float_matrix(double_matrix* matrix_double, float_matrix* matrix_float);
void double_matrix_destroy(double_matrix* matrix);




#endif