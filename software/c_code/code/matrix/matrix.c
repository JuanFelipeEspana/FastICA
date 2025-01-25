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
    (matrix->row_vector) = (rows == 1) ? 1 : 0;
    (matrix->col_vector) = (cols == 1) ? 1 : 0;
    (matrix->address) = (float* ) malloc((rows*cols) * sizeof(int32_t));
    (matrix->max_exponent) = 0;
    (matrix->min_exponent) = 0;
}

void float_matrix_find_range(float_matrix* matrix)
{
    int16_t exponent = 0;
    uint8_t max_exponent;
    uint8_t min_exponent;
    for(uint32_t i = 0; i < (matrix->rows); i++)
    {
        for(uint32_t j = 0; j < (matrix->cols); j++)
        {
            exponent = (float32_get_exponent(*((matrix->address)+(i*(matrix->cols))+j))) - 142;
            if((i == 0) && (j == 0))
            {
                max_exponent = exponent;
                min_exponent = exponent;
            }
            else
            {
                if(max_exponent < exponent)
                {
                    max_exponent = exponent;
                }
                if(min_exponent > exponent)
                {
                    min_exponent = exponent;
                }
            }
        }
    }

    (matrix->max_exponent) = max_exponent;
    (matrix->min_exponent) = min_exponent;
}

void float_matrix_fill_random(float_matrix* matrix, uint32_t limit)
{
    for(uint64_t i = 0; i < ((matrix->rows)*(matrix->cols)); i++)
    {
        *((matrix->address)+i) = (random_number_generate(limit));
    }
}

void float_matrix_fill_zeros(float_matrix* matrix)
{
    for(uint64_t i = 0; i < ((matrix->rows)*(matrix->cols)); i++)
    {
        *((matrix->address)+i) = 0;
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

float float_matrix_multiply(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result)
{
    float result_first_value;
    if((matrix1->cols) != (matrix2->rows))
    {
        printf("ERROR: Matrices have different dimension so can't be multiplied, nothing was done\n");
        return 0;
    }
    else if(((matrix1->rows) != 1) || ((matrix2->cols) != 1))
    {
        if(((result->rows) != (matrix1->rows)) || ((result->cols) != (matrix2->cols)))
        {
            printf("ERROR: Result matrix can't store all results, so nothing was done\n");
            return 0;
        }
    }
    
    float acc;
    for(uint32_t i = 0; i < (matrix1->rows); i++)
    {
        for(uint32_t j = 0; j < (matrix2->cols); j++)
        {
            acc = 0;
            for(uint32_t k = 0; k < (matrix1->cols); k++)
            {
                acc += (*((matrix1->address)+((i*(matrix1->cols)+k)))) * (*((matrix2->address)+((k*(matrix2->cols)+j))));
            }
            if(((matrix1->rows) != 1) || ((matrix2->cols) != 1))
            {
                *((result->address)+((i*(result->cols))+j)) = acc;
            }
            if((i == 0) && (j == 0))
            {
                result_first_value = acc;
            }
        }
    }
    return result_first_value;
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



void float_matrix_multiply_scalar(float_matrix* matrix, float scalar, float_matrix* result_matrix)
{
    if(((result_matrix->rows) != (matrix->rows)) || ((result_matrix->cols) != (matrix->cols)))
    {
        printf("ERROR: result_matrix has different dimensions than matrix, so nothing was done. \n");
        return ;
    }
    for(uint64_t i = 0; i < ((result_matrix->rows)*(result_matrix->cols)); i++)
    {
        *((result_matrix->address)+i) = (*((matrix->address)+i)) * scalar;
    }
}

void float_matrix_mean_cols(float_matrix* data_matrix, float_matrix* mean_vector)
{
    float acc = 0;
    if(!(mean_vector->row_vector))
    {
        printf("ERROR: mean_vector isn't a row vector, so nothing was done.\n");
        return ;
    }
    else if((data_matrix->cols) != (mean_vector->cols))
    {
        printf("ERROR: data_matrix columns doesn't match mean_vector columns, so nothing was done.\n");
        return ;
    }
    for(uint32_t i = 0; i < (data_matrix->cols); i++)
    {
        acc = 0;
        for(uint32_t j = 0; j < (data_matrix->rows); j++)
        {
            acc += (*((data_matrix->address)+(j*(data_matrix->cols))+i));
        }
        *((mean_vector->address)+i) = acc/(data_matrix->rows);//(data_matrix->rows);
    }
}

void float_matrix_mean_rows(float_matrix* data_matrix, float_matrix* mean_vector)
{
    if(!(mean_vector->col_vector))
    {
        printf("ERROR: mean_vector isn't a column vector, so nothing was done.\n");
        return ;
    }
    else if((data_matrix->rows) != (mean_vector->rows))
    {
        printf("ERROR: data_matrix rows doesn't match mean_vector rows, so nothing was done.\n");
        return ;
    }

    for(uint32_t i = 0; i < (data_matrix->rows); i++)
    {
        *((mean_vector->address)+i) = 0;
        for(uint32_t j = 0; j < (data_matrix->cols); j++)
        {
            *((mean_vector->address)+i) += *((data_matrix->address)+(i*(data_matrix->cols))+j);
        }
        *((mean_vector->address)+i) /= (data_matrix->cols);
    }
}

void float_matrix_minus_vector_col(float_matrix* data_matrix, float_matrix* vector, float_matrix* result_matrix)
{
    if(!(vector->col_vector))
    {
        printf("ERROR: vector isn't a column vector, so nothing was done.\n");
        return ;
    }
    else if((data_matrix->rows) != (vector->rows))
    {
        printf("ERROR: data_matrix columns doesn't match vector columns, so nothing was done.\n");
        return ;
    }
    else if(((result_matrix->rows) != (data_matrix->rows)) || ((result_matrix->cols) != (data_matrix->cols)))
    {
        printf("ERROR: result_matrix has different dimensions than data_matrix, so nothing was done. \n");
        return ;
    }

    for(uint32_t i = 0; i < (result_matrix->rows); i++)
    {
        for(uint32_t j = 0; j < (result_matrix->cols); j++)
        {
            *((result_matrix->address)+(j*(result_matrix->cols))+i) = *((data_matrix->address)+(j*(data_matrix->cols))+i) - *((vector->address)+i);
        }
    }
}

void float_matrix_minus_vector_row(float_matrix* data_matrix, float_matrix* vector, float_matrix* result_matrix)
{
    if(!(vector->row_vector))
    {
        printf("ERROR: vector isn't a row vector, so nothing was done.\n");
        return ;
    }
    else if((data_matrix->cols) != (vector->cols))
    {
        printf("ERROR: data_matrix rows doesn't match vector rows, so nothing was done.\n");
        return ;
    }
    else if(((result_matrix->rows) != (data_matrix->rows)) || ((result_matrix->cols) != (data_matrix->cols)))
    {
        printf("ERROR: result_matrix has different dimensions than data_matrix, so nothing was done. \n");
        return ;
    }

    for(uint32_t i = 0; i < (result_matrix->cols); i++)
    {
        for(uint32_t j = 0; j < (result_matrix->rows); j++)
        {
            *((result_matrix->address)+(j*(result_matrix->cols))+i) = *((data_matrix->address)+(j*(data_matrix->cols))+i) - *((vector->address)+i);
        }
    }

}

void float_matrix_transpose(float_matrix* matrix, float_matrix* matrix_transposed)
{
    if(!(((matrix->rows) == (matrix_transposed->cols)) && ((matrix->cols) == (matrix_transposed->rows))))
    {
        printf("ERROR: matrix and matrix_transposed have different dimensions, so nothing was done.\n");
    }
    for(uint32_t i = 0; i < (matrix->rows); i++)
    {
        for(uint32_t j = 0; j < (matrix->cols); j++)
        {
            *((matrix_transposed->address)+(j*(matrix_transposed->cols))+i) = *((matrix->address)+(i*(matrix->cols))+j);
        }
    }
}

void float_matrix_copy_row(float_matrix* matrix, uint32_t row, float_matrix* copied_row)
{
    if(!(copied_row->row_vector))
    {
        printf("ERROR: copied_row isn't a row vector, so nothing was done.\n");
        return ;
    }
    else if((row >= (matrix->rows)))
    {
        printf("ERROR: asked row can't be reached in given matrix by its dimensions, so nothing was done.\n");
        return ;
    }
    else if((copied_row->cols) != (matrix->cols))
    {
        printf("WARNING: copied_row can't copy all columns, only first ones will be copied.\n");
    }

    for(uint32_t i = 0; i < (copied_row->cols); i++)
    {
        *((copied_row->address)+i) = *((matrix->address)+(row*(matrix->cols))+i);
    }
}

void float_matrix_copy_col(float_matrix* matrix, uint32_t col, float_matrix* copied_col)
{
    if(!(copied_col->col_vector))
    {
        printf("ERROR: copied_col isn't a col vector, so nothing was done.\n");
        return ;
    }
    else if((col >= (matrix->cols)))
    {
        printf("ERROR: asked col can't be reached in given matrix by its dimensions, so nothing was done.\n");
        return ;
    }
    else if((copied_col->cols) != (matrix->cols))
    {
        printf("WARNING: copied_row can't copy all columns, only first ones will be copied.\n");
    }

    for(uint32_t i = 0; i < (copied_col->cols); i++)
    {
        *((copied_col->address)+i) = *((matrix->address)+(i*(matrix->cols))+col);
    }
}

void float_matrix_paste_row(float_matrix* vector, uint32_t row, float_matrix* matrix)
{
    if(!(vector->row_vector))
    {
        printf("ERROR: vector isn't a row vector, so nothing was done.\n");
    }
    else if((vector->cols) != (matrix->cols))
    {
        printf("ERROR: vector columns doesn't match matrix columns, so nothing was done.\n");
    }
    for(uint32_t i = 0; i < (matrix->cols); i++)
    {
        *((matrix->address)+(row*(matrix->cols))+i) = *((vector->address)+i);
    }
}

void float_matrix_paste_col(float_matrix* vector, uint32_t col, float_matrix* matrix)
{
    if(!(vector->col_vector))
    {
        printf("ERROR: vector isn't a col vector, so nothing was done.\n");
    }
    else if((vector->rows) != (matrix->rows))
    {
        printf("ERROR: vector rows doesn't match matrix rows, so nothing was done.\n");
    }
    
    for(uint32_t i = 0; i < (matrix->rows); i++)
    {
        *((matrix->address)+(i*(matrix->cols))+col) = *((vector->address)+i);
    }
}

void float_matrix_power_minus_one(float_matrix* data_matrix, float_matrix* result_matrix)
{
    if(((result_matrix->rows) != (data_matrix->rows)) || ((result_matrix->cols) != (data_matrix->cols)))
    {
        printf("ERROR: result_matrix has different dimensions than data_matrix, so nothing was done. \n");
        return ;
    }

    for(uint64_t i = 0; i < ((result_matrix->rows)*(result_matrix->cols)); i++)
    {
        *((result_matrix->address)+i) = (1.0)/(*((data_matrix->address)+i));
    }
}

void float_matrix_absolute_value(float_matrix* original_matrix, float_matrix* abs_matrix)
{
    if(((abs_matrix->rows) != (original_matrix->rows)) || ((abs_matrix->cols) != (original_matrix->cols)))
    {
        printf("ERROR: abs_matrix has different dimensions than original_matrix, so nothing was done. \n");
        return ;
    }

    for(uint64_t i = 0; i < ((abs_matrix->rows)*(abs_matrix->cols)); i++)
    {
        *((abs_matrix->address)+i) = (*((original_matrix->address)+i) < 0) ? -(*((original_matrix->address)+i)) : (*((original_matrix->address)+i));
    }
}

void float_matrix_sum(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result_matrix)
{
    if(((matrix1->rows) != (matrix2->rows)) || ((matrix1->cols) != (matrix2->cols)))
    {
        printf("ERROR: matrix1 has different dimensions than matrix2, so nothing was done. \n");
        return ;
    }
    else if(((matrix2->rows) != (result_matrix->rows)) || ((matrix2->cols) != (result_matrix->cols)))
    {
        printf("ERROR: result_matrix has different dimensions than operand matrix, so nothing was done.\n");
        return ;
    }

    for(uint64_t i = 0; i < ((result_matrix->rows)*(result_matrix->cols)); i++)
    {
        *((result_matrix->address)+i) = *((matrix1->address)+i) + *((matrix2->address)+i);
    }

}

void float_matrix_minus(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result_matrix)
{
    if(((matrix1->rows) != (matrix2->rows)) || ((matrix1->cols) != (matrix2->cols)))
    {
        printf("ERROR: matrix1 has different dimensions than matrix2, so nothing was done. \n");
        return ;
    }
    else if(((matrix2->rows) != (result_matrix->rows)) || ((matrix2->cols) != (result_matrix->cols)))
    {
        printf("ERROR: result_matrix has different dimensions than operand matrix, so nothing was done.\n");
        return ;
    }

    for(uint64_t i = 0; i < ((result_matrix->rows)*(result_matrix->cols)); i++)
    {
        *((result_matrix->address)+i) = *((matrix1->address)+i) - *((matrix2->address)+i);
    }

}

void float_matrix_substract(float_matrix* matrix1, float_matrix* matrix2, float_matrix* result_matrix)
{
    if(((matrix1->rows) != (matrix2->rows)) || ((matrix1->cols) != (matrix2->cols)))
    {
        printf("ERROR: matrix1 has different dimensions than matrix2, so nothing was done. \n");
        return ;
    }
    else if(((matrix2->rows) != (result_matrix->rows)) || ((matrix2->cols) != (result_matrix->cols)))
    {
        printf("ERROR: result_matrix has different dimensions than operand matrix, so nothing was done.\n");
        return ;
    }

    for(uint64_t i = 0; i < ((result_matrix->rows)*(result_matrix->cols)); i++)
    {
        *((result_matrix->address)+i) = *((matrix1->address)+i) - *((matrix2->address)+i);
    }
}

void float_matrix_vector_normalize(float_matrix* matrix, float_matrix* result_matrix)
{
    if(!((matrix->row_vector) || (matrix->col_vector)))
    {
        printf("ERROR: matrix isn't a vector, so nothing was done.\n");
        return ;
    }
    else if(((matrix->rows) != (result_matrix->rows)) || ((matrix->cols) != (result_matrix->cols)))
    {
        printf("ERROR: result_matrix has different dimensions than operand matrix, so nothing was done.\n");
        return ;
    }

    float magnitude = 0.0;
    for(uint64_t i = 0; i < ((matrix->rows)*(matrix->cols)); i++)
    {
        magnitude += (*((matrix->address)+i)) * (*((matrix->address)+i));
    }
    magnitude = (float) (sqrt(magnitude));
    printf("La magnitud total es %f\n", magnitude);

    for(uint64_t i = 0; i < ((matrix->rows)*(matrix->cols)); i++)
    {
        *((result_matrix->address)+i) = *((matrix->address)+i) / magnitude;
    }
}

void float_matrix_svd_decomposition_lapacke(float_matrix* matrix, float_matrix* u, float_matrix* sigma, float_matrix* v)
{
    int min = ((matrix->rows) < (matrix->cols)) ? (matrix->rows) : (matrix->cols);
    double superb[min-1];
    double_matrix matrix_double;
    double_matrix_create(&matrix_double, (matrix->rows), (matrix->cols));
    float_matrix_to_double_matrix(matrix, &matrix_double);
    double_matrix u_double;
    double_matrix_create(&u_double, (u->rows), (u->cols));
    float_matrix_to_double_matrix(u, &u_double);
    double_matrix sigma_double;
    double_matrix_create(&sigma_double, (sigma->rows), (sigma->cols));
    float_matrix_to_double_matrix(sigma, &sigma_double);
    double_matrix v_double;
    double_matrix_create(&v_double, (v->rows), (v->cols));
    float_matrix_to_double_matrix(v, &v_double);
    LAPACKE_dgesvd(LAPACK_ROW_MAJOR, 'A', 'N', (matrix_double.rows), (matrix_double.cols), (matrix_double.address), (matrix_double.cols), (sigma_double.address), (u_double.address), (matrix_double.rows), NULL, (matrix_double.cols), superb);
    double_matrix_to_float_matrix(&u_double, u);
    double_matrix_to_float_matrix(&sigma_double, sigma);
    double_matrix_to_float_matrix(&v_double, v);
    double_matrix_destroy(&matrix_double);
    double_matrix_destroy(&u_double);
    double_matrix_destroy(&sigma_double);
    double_matrix_destroy(&v_double);
}

void float_matrix_print(float_matrix* matrix, char separator)
{
    float value = 0;
    for(uint32_t i = 0; i < (matrix->rows); i++)
    {
        for(uint32_t j = 0; j < (matrix->cols); j++)
        {
            value = *((matrix->address)+((i*(matrix->cols))+j));
            printf("%f", value);
            if(j != ((matrix->cols)-1))
            {
                printf("%c", separator);
            }
            else
            {
                printf("\n");
            }
        }
    }
    printf("\n");
}

void float_matrix_print_file(float_matrix* matrix, char separator, FILE* file_to_write)
{
    float value = 0;
    for(uint32_t i = 0; i < (matrix->rows); i++)
    {
        for(uint32_t j = 0; j < (matrix->cols); j++)
        {
            value = *((matrix->address)+((i*(matrix->cols))+j));
            fprintf(file_to_write, "%f", value);
            if(j != ((matrix->cols)-1))
            {
                fprintf(file_to_write, "%c", separator);
            }
            else
            {
                fprintf(file_to_write, "\n");
            }
        }
    }
    fprintf(file_to_write, "\n");
}


void float_matrix_destroy(float_matrix* matrix)
{
    free(matrix->address);
}


void double_matrix_create(double_matrix* matrix, uint32_t rows, uint32_t cols)
{
    (matrix->rows) = rows;
    (matrix->cols) = cols;
    (matrix->row_vector) = (rows == 1) ? 1 : 0;
    (matrix->col_vector) = (cols == 1) ? 1 : 0;
    (matrix->address) = (double* ) malloc((rows*cols) * sizeof(double));
}

void float_matrix_to_double_matrix(float_matrix* matrix_float, double_matrix* matrix_double)
{
    for(uint32_t i = 0; i < (matrix_double->rows); i++)
    {
        for(uint32_t j = 0; j < (matrix_double->cols); j++)
        {
            *((matrix_double->address)+(i*(matrix_double->cols))+j) = (double) *((matrix_float->address)+(i*(matrix_float->cols))+j);
        }
    }
}

void double_matrix_to_float_matrix(double_matrix* matrix_double, float_matrix* matrix_float)
{
    for(uint32_t i = 0; i < (matrix_float->rows); i++)
    {
        for(uint32_t j = 0; j < (matrix_float->cols); j++)
        {
            *((matrix_float->address)+(i*(matrix_float->cols))+j) = (float) *((matrix_double->address)+(i*(matrix_double->cols))+j);
        }
    }
}

void double_matrix_destroy(double_matrix* matrix)
{
    free(matrix->address);
}