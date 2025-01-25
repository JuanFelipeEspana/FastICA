#include <matrix.h>

void int32_matrix_create(int32_matrix* matrix, uint32_t rows, uint32_t cols)
{
    (matrix->rows) = rows;
    (matrix->cols) = cols;
    (matrix->vector) = ((rows == 1) || (cols == 1)) ? 1 : 0;
    (matrix->address) = (int32_t* ) malloc((rows*cols) * sizeof(int32_t));
}

void int32_matrix_fill_random(int32_matrix* matrix, uint32_t limit)
{
    for(uint64_t i = 0; i < ((matrix->rows)*(matrix->cols)); i++)
    {
        *((matrix->address)+i) = random_number_generate(limit);
    }
}

void float_matrix_to_int32_matrix(float_matrix* float_matrix, int32_matrix* int32_matrix, int8_t offset)
{
    for(uint64_t i = 0; i < ((float_matrix->rows)*(float_matrix->cols)); i++)
    {
        *((int32_matrix->address)+i) = float32_to_sign_magnitude_integer16(*((float_matrix->address)+i), offset);
    }
}

void int32_matrix_to_sign_magnitude_integer16(int32_matrix* matrix_to_parse, int32_matrix* matrix_to_store)
{
    for(uint64_t i = 0; i < ((matrix_to_parse->rows)*(matrix_to_parse->cols)); i++)
    {
        *((matrix_to_store->address)+i) = int32_to_sign_magnitude_integer16(*((matrix_to_parse->address)+i));
    }
}

void int32_matrix_multiply(int32_matrix* matrix1, int32_matrix* matrix2, int32_matrix* result)
{
    if((matrix1->cols) != (matrix2->rows))
    {
        printf("ERROR: Matrices have different dimension so can't be multiplied, nothing was done\n");
    }
    else if(((result->rows) != (matrix1->rows)) || ((result->cols) != (matrix2->cols)))
    {
        printf("ERROR: Result matrix can't store all results, so nothing was done\n");
    }
    else
    {
        int32_t acc;
        for(uint32_t i = 0; i < (result->rows); i++)
        {
            for(uint32_t j = 0; j < (result->cols); j++)
            {
                acc = 0;
                for(uint32_t k = 0; k < (matrix1->cols); k++)
                {
                    acc += (*((matrix1->address)+((i*(matrix1->cols)+k)))) * (*((matrix2->address)+((k*(matrix2->cols)+j))));
                }
                *((result->address)+((i*(result->cols))+j)) = acc;
            }
        }
    }
}

void int32_matrix_multiply_custom(int32_matrix* matrix1, int32_matrix* matrix2, int32_matrix* result)
{
    if((matrix1->cols) != (matrix2->rows))
    {
        printf("ERROR: Matrices have different dimension so can't be multiplied, nothing was done\n");
    }
    else if(((result->rows) != (matrix1->rows)) || ((result->cols) != (matrix2->cols)))
    {
        printf("ERROR: Result matrix can't store all results, so nothing was done\n");
    }
    else
    {
        int32_t acc;
        for(uint32_t i = 0; i < (result->rows); i++)
        {
            for(uint32_t j = 0; j < (result->cols); j++)
            {
                acc = 0;
                for(uint32_t k = 0; k < (matrix1->cols); k++)
                {
                    acc += multiply_sign_magnitude_integer16(*((matrix1->address)+((i*(matrix1->cols)+k))), *((matrix2->address)+((k*(matrix2->cols)+j))));
                }
                *((result->address)+((i*(result->cols))+j)) = acc;
            }
        }
    }
}

void int32_matrix_print(int32_matrix* matrix, uint8_t print_type)
{
    int32_t value = 0;
    for(uint32_t i = 0; i < (matrix->rows); i++)
    {
        printf("-- ");
        for(uint32_t j = 0; j < (matrix->cols); j++)
        {
            value = *((matrix->address)+((i*(matrix->cols))+j));
            if(print_type == 0)
            {
                printf("%d", value);
            }
            else
            {
                printf("%08x", value);
            }
            if(j != ((matrix->cols)-1))
            {
                printf(" ");
            }
            else
            {
                printf("\n");
            }
        }
    }
    printf("\n");
}

void int32_matrix_free(int32_matrix* matrix)
{
    free(matrix->address);
}

void float_matrix_create(float_matrix* matrix, uint32_t rows, uint32_t cols)
{
    (matrix->rows) = rows;
    (matrix->cols) = cols;
    (matrix->vector) = ((rows == 1) || (cols == 1)) ? 1 : 0;
    (matrix->address) = (float* ) malloc((rows*cols) * sizeof(int32_t));
}

void float_matrix_fill_random(float_matrix* matrix, uint32_t limit, uint8_t decimal)
{
    for(uint64_t i = 0; i < ((matrix->rows)*(matrix->cols)); i++)
    {
        if(decimal == 1)
        {
            *((matrix->address)+i) = (1.0 / random_number_generate(limit));
        }
        else
        {
            *((matrix->address)+i) = random_number_generate(limit);
        }
    }
}

void int32_matrix_to_float_matrix(int32_matrix* int32_matrix, float_matrix* float_matrix, int8_t offset)
{
    for(uint64_t i = 0; i < ((int32_matrix->rows)*(int32_matrix->cols)); i++)
    {
        *((float_matrix->address)+i) = sign_magnitude_integer16_to_float(*((int32_matrix->address)+i), offset);
    }
}

void int32_matrix_full_to_float_matrix(int32_matrix* int32_matrix, float_matrix* float_matrix, int8_t offset)
{
    for(uint64_t i = 0; i < ((int32_matrix->rows)*(int32_matrix->cols)); i++)
    {
        *((float_matrix->address)+i) = int32_to_float(*((int32_matrix->address)+i), offset);
    }
}

void float_matrix_multiply(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result)
{
    if((matrix1->cols) != (matrix2->rows))
    {
        printf("ERROR: Matrices have different dimension so can't be multiplied, nothing was done\n");
    }
    else if(((result->rows) != (matrix1->rows)) || ((result->cols) != (matrix2->cols)))
    {
        printf("ERROR: Result matrix can't store all results, so nothing was done\n");
    }
    else
    {
        float acc;
        for(uint32_t i = 0; i < (result->rows); i++)
        {
            for(uint32_t j = 0; j < (result->cols); j++)
            {
                acc = 0;
                for(uint32_t k = 0; k < (matrix1->cols); k++)
                {
                    acc += (*((matrix1->address)+((i*(matrix1->cols)+k)))) * (*((matrix2->address)+((k*(matrix2->cols)+j))));
                }
                *((result->address)+((i*(result->cols))+j)) = acc;
            }
        }
    }
}

void float_matrix_multiply_int32_matrix(float_matrix* matrix1, int32_matrix* matrix2, float_matrix* result)
{
    if((matrix1->cols) != (matrix2->rows))
    {
        printf("ERROR: Matrices have different dimension so can't be multiplied, nothing was done\n");
    }
    else if(((result->rows) != (matrix1->rows)) || ((result->cols) != (matrix2->cols)))
    {
        printf("ERROR: Result matrix can't store all results, so nothing was done\n");
    }
    else
    {
        float acc;
        for(uint32_t i = 0; i < (result->rows); i++)
        {
            for(uint32_t j = 0; j < (result->cols); j++)
            {
                acc = 0;
                for(uint32_t k = 0; k < (matrix1->cols); k++)
                {
                    acc += (*((matrix1->address)+((i*(matrix1->cols)+k)))) * (*((matrix2->address)+((k*(matrix2->cols)+j))));
                }
                *((result->address)+((i*(result->cols))+j)) = acc;
            }
        }
    }
}

void float_matrix_print(float_matrix* matrix)
{
    float value = 0;
    for(uint32_t i = 0; i < (matrix->rows); i++)
    {
        printf("-- ");
        for(uint32_t j = 0; j < (matrix->cols); j++)
        {
            value = *((matrix->address)+((i*(matrix->cols))+j));
            printf("%f", value);
            if(j != ((matrix->cols)-1))
            {
                printf(" ");
            }
            else
            {
                printf("\n");
            }
        }
    }
    printf("\n");
}

void float_matrix_free(float_matrix* matrix)
{
    free(matrix->address);
}

int32_t random_number_generate(uint32_t limit)
{
    int32_t random_number = rand() % (limit);
    uint8_t sign = rand() % 2;
    if(sign)
    {
        random_number *= -1;
    }

    return random_number;
}