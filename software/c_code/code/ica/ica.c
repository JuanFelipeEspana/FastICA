#include <ica.h>

void ica_whiten(float_matrix* matrix, float_matrix* matrix_whitened)
{
    float_matrix matrix_transposed;
    float_matrix_create(&matrix_transposed, matrix->cols, matrix->rows);
    float_matrix matrix_mean_cols;
    float_matrix_create(&matrix_mean_cols, 1, matrix->cols);
    float_matrix matrix_without_mean_cols;
    float_matrix_create(&matrix_without_mean_cols, matrix->rows, matrix->cols);
    float_matrix matrix_transposed_svd_u;
    float_matrix_create(&matrix_transposed_svd_u, matrix_transposed.rows, matrix_transposed.rows);
    float_matrix matrix_transposed_svd_sigma;
    float_matrix_create(&matrix_transposed_svd_sigma, matrix_transposed.rows, matrix_transposed.rows);
    float_matrix matrix_transposed_svd_v;
    float_matrix_create(&matrix_transposed_svd_v, matrix->cols, matrix->cols);
    float_matrix matrix_transposed_svd_u_row_first_signs;
    float_matrix_create(&matrix_transposed_svd_u_row_first_signs, 1, matrix_transposed_svd_u.cols);
    float_matrix matrix_transposed_svd_sigma_row_first;
    float_matrix_create(&matrix_transposed_svd_sigma_row_first, 1, matrix_transposed_svd_sigma.cols);
    float_matrix matrix_transposed_svd_sigma_row_first_power_minus_one;
    float_matrix_create(&matrix_transposed_svd_sigma_row_first_power_minus_one, 1, matrix_transposed_svd_sigma.cols);
    float_matrix matrix_transposed_svd_u_signs_changed;
    float_matrix_create(&matrix_transposed_svd_u_signs_changed, matrix_transposed_svd_u.rows, matrix_transposed_svd_u.cols);

    float_matrix matrix_transpose_matrix_whitening;
    float_matrix_create(&matrix_transpose_matrix_whitening, matrix_transposed_svd_u.rows, matrix_transposed_svd_u.cols);
    float_matrix matrix_transpose_whitened; 
    float_matrix_create(&matrix_transpose_whitened, matrix_transposed.rows, matrix_transposed.cols);


    float_matrix_mean_cols(matrix, &matrix_mean_cols);
    
    float_matrix_minus_vector_row(matrix, &matrix_mean_cols, &matrix_without_mean_cols);
    
    float_matrix_transpose(&matrix_without_mean_cols, &matrix_transposed);
    
    //SVD DECOMPOSITION FUNCTION U SIGMA V
    float_matrix_svd_decomposition_lapacke(&matrix_transposed, &matrix_transposed_svd_u, &matrix_transposed_svd_sigma, &matrix_transposed_svd_v);    
    
    //TAKE SIGNS FROM FIRST ROW U
    for(uint16_t i = 0; i < (matrix_transposed_svd_u.cols); i++)
    {
        *((matrix_transposed_svd_u_row_first_signs.address)+i) = (*((matrix_transposed_svd_u.address)+i) < 0) ? -1 : 1;
    }
    //COPY FIRST ROW FROM SIGMA
    float_matrix_copy_row(&matrix_transposed_svd_sigma, 0, &matrix_transposed_svd_sigma_row_first);
    //CALCULATE SIGMA FIRST ROW AND ELEVATE IT TO MINUS ONE POWER
    float_matrix_power_minus_one(&matrix_transposed_svd_sigma_row_first, &matrix_transposed_svd_sigma_row_first_power_minus_one);
    //MULTIPLY SIGNS FROM FIRST ROW U WITH SIGMA
    for(uint32_t i = 0; i < (matrix_transposed_svd_u_signs_changed.cols); i++)
    {
        for(uint32_t j = 0; j < (matrix_transposed_svd_u_signs_changed.rows); j++)
        {
            *((matrix_transposed_svd_u_signs_changed.address)+(j*(matrix_transposed_svd_u_signs_changed.cols))+i) = (*((matrix_transposed_svd_u.address)+(j*(matrix_transposed_svd_u.cols))+i)) * (*((matrix_transposed_svd_u_row_first_signs.address)+i));
        }
    }
    //MULTIPLY SIGMA FIRST ROW POWER MINUS ONE WITH U SIGN CHANGED
    for(uint32_t i = 0; i < (matrix_transposed_svd_u_signs_changed.cols); i++)
    {
        for(uint32_t j = 0; j < (matrix_transposed_svd_u_signs_changed.rows); j++)
        {
            *((matrix_transpose_matrix_whitening.address)+(j*(matrix_transpose_matrix_whitening.cols))+i) = (*((matrix_transposed_svd_u_signs_changed.address)+(j*(matrix_transposed_svd_u_signs_changed.cols))+i)) * (*((matrix_transposed_svd_sigma_row_first_power_minus_one.address)+i));
        }
    }
    float_matrix_print(&matrix_transpose_matrix_whitening, ';');
    float_matrix_multiply(&matrix_transpose_matrix_whitening, &matrix_transposed, &matrix_transpose_whitened);
    float_matrix_transpose(&matrix_transpose_whitened, matrix_whitened);
    
    
    float_matrix_destroy(&matrix_transposed);
    float_matrix_destroy(&matrix_mean_cols);
    float_matrix_destroy(&matrix_without_mean_cols);
    float_matrix_destroy(&matrix_transposed_svd_u);
    float_matrix_destroy(&matrix_transposed_svd_sigma);
    float_matrix_destroy(&matrix_transposed_svd_v);
    float_matrix_destroy(&matrix_transposed_svd_u_row_first_signs);
    float_matrix_destroy(&matrix_transposed_svd_sigma_row_first);
    float_matrix_destroy(&matrix_transposed_svd_sigma_row_first_power_minus_one);
    float_matrix_destroy(&matrix_transposed_svd_u_signs_changed);
    float_matrix_destroy(&matrix_transpose_matrix_whitening);
    float_matrix_destroy(&matrix_transpose_whitened);
}

void ica_deflanatory_orthogonalization(float_matrix* wp, uint32_t iteration, float_matrix* w, float_matrix* result)
{
    if((wp->row_vector) != 1)
    {
        printf("ERROR: wp input is not a row vector, nothing was done.\n");
        return ;
    }
    else if((wp->cols) != (w->cols))
    {
        printf("ERROR: wp and w size do not fit, nothing was done.\n");
        return ;
    }
    float_matrix wp_transposed;
    float_matrix_create(&wp_transposed, (wp->cols), 1);
    float_matrix wj;
    float_matrix_create(&wj, 1, (wp->cols));
    float_matrix w_product;
    float_matrix_create(&w_product, 1, (wp->cols));
    float_matrix sum;
    float_matrix_create(&sum, 1, (wp->cols));

    float_matrix_fill_zeros(&sum);
    float_matrix_fill_zeros(&w_product);
    float_matrix_transpose(wp, &wp_transposed);
    
    for (uint8_t k = 0; k < iteration; k++)
    {
        float_matrix_copy_row(w, k, &wj);
        float_matrix_multiply_scalar(&wj, float_matrix_multiply(&wj, &wp_transposed, NULL), &w_product);
        printf("La multiplicacion: \n");
        float_matrix_print(&w_product, ';');
        float_matrix_sum(&sum, &w_product, &sum);
        printf("La suma: \n");
        float_matrix_print(&sum, ';');
    }
    printf("sum: \n");
    float_matrix_print(&sum, ';');
    float_matrix_minus(wp, &sum, result);
    
    
    printf("La resta: \n");
    float_matrix_print(result, ';');
    
    float_matrix_destroy(&sum);
    float_matrix_destroy(&w_product);
}

float ica_g_fun(float_matrix* z, float_matrix* wp, int function)
{
    float y, result;
    y = float_matrix_multiply(z, wp, NULL);
    
    if(function==1)
        result=tanh(y);
    else if(function==2)
        result=y*exp(-pow(y,2)*0.5);
    else
        result=pow(y,3);

    return result;
}

float ica_gprime_fun(float_matrix* z, float_matrix* wp, int function)
{
    float y, result;
    y = float_matrix_multiply(z, wp, NULL);
    switch(function)
    {
        case 1:
            result = 1-pow(tanh(y),2);
            break;
        case 2:
            result = (1-pow(y,2))*exp(-pow(y,2)*0.5);
            break;
        case 3:
            result = 3*pow(y,2);
            break;
    }   
    return result;
}

void ica_calculate_matrix_unmixing(float_matrix* ica_matrix_mixed, uint32_t ica_number_samples, uint16_t ica_independent_components, float_matrix* ica_matrix_unmixing, float tol, uint32_t max_iter, uint8_t function)
{
    float_matrix ica_matrix_unmixing_row;
    float_matrix_create(&ica_matrix_unmixing_row, 1, ica_independent_components);
    float_matrix ica_matrix_unmixing_row_transpose;
    float_matrix_create(&ica_matrix_unmixing_row_transpose, ica_independent_components, 1);
    float_matrix g_vector;
    float_matrix_create(&g_vector, 1, ica_independent_components);
    float_matrix gprime_vector;
    float_matrix_create(&gprime_vector, ica_independent_components, 1);
    float_matrix gprime_vector_transposed;
    float_matrix_create(&gprime_vector_transposed, 1, ica_independent_components);
    float_matrix w_temp;
    float_matrix_create(&w_temp, 1, ica_independent_components);
    float_matrix w_temp_transposed;
    float_matrix_create(&w_temp_transposed, ica_independent_components, 1);
    float_matrix fun_vector;
    float_matrix_create(&fun_vector, 1, ica_independent_components);
    float_matrix ica_matrix_mixed_row;
    float_matrix_create(&ica_matrix_mixed_row, 1, ica_independent_components);

    float mean_scalar, convergence_difference;
    uint32_t iter_count;
    for(uint8_t p = 0; p < ica_independent_components; p++){
        //float_matrix_fill_random(&ica_matrix_unmixing_row, 10);

        *((ica_matrix_unmixing_row.address)) = (p*3)+1;
        *((ica_matrix_unmixing_row.address)+1) = (p*3)+2;
        *((ica_matrix_unmixing_row.address)+2) = (p*3)+3;
        float_matrix_vector_normalize(&ica_matrix_unmixing_row, &ica_matrix_unmixing_row);
        printf("aleatorio:\n");
        float_matrix_print(&ica_matrix_unmixing_row, ';');

        float_matrix_transpose(&ica_matrix_unmixing_row, &ica_matrix_unmixing_row_transpose);
        convergence_difference = tol+1; 
        iter_count = 0; 
        while((iter_count < max_iter) && (convergence_difference > tol)){
            printf("iteration %d\n", iter_count);
            float_matrix_fill_zeros(&g_vector);
            mean_scalar = 0;
            for (uint32_t i = 0; i < ica_number_samples; i++){
                float_matrix_copy_row(ica_matrix_mixed, i, &ica_matrix_mixed_row);
                float_matrix_multiply_scalar(&ica_matrix_mixed_row, ((ica_g_fun(&ica_matrix_mixed_row, &ica_matrix_unmixing_row_transpose, function)) * (1.0/ica_number_samples)), &fun_vector);
                printf("fun_vector:\n");
                float_matrix_print(&fun_vector, ';');
                float_matrix_sum(&g_vector, &fun_vector, &g_vector);
                printf("suma_vector:\n");
                float_matrix_print(&g_vector, ';');
                mean_scalar = mean_scalar + (ica_gprime_fun(&ica_matrix_mixed_row, &ica_matrix_unmixing_row_transpose, function)) * (1.0/ica_number_samples);
                printf("mean_scalar %f \n", mean_scalar);
            }
            float_matrix_multiply_scalar(&ica_matrix_unmixing_row_transpose, mean_scalar, &gprime_vector);
            printf("g:\n");
            float_matrix_print(&g_vector, ';');
            printf("gprime_vector:\n");
            float_matrix_print(&gprime_vector, ';');

            float_matrix_transpose(&gprime_vector, &gprime_vector_transposed);
            float_matrix_minus(&g_vector, &gprime_vector_transposed, &w_temp);
            printf("w_temp:\n");
            float_matrix_print(&w_temp, ';');

            ica_deflanatory_orthogonalization(&w_temp, p, ica_matrix_unmixing, &w_temp);
            printf("ortho:\n");
            float_matrix_print(&w_temp, ';');

            float_matrix_vector_normalize(&w_temp, &w_temp);
            printf("norm:\n");
            float_matrix_print(&w_temp, ';');

            convergence_difference = fabs(fabs(float_matrix_multiply(&w_temp, &ica_matrix_unmixing_row_transpose, NULL))-1);
            //float_matrix_transpose(&w_temp, &w_temp_transposed);
            float_matrix_paste_row(&w_temp, 0, &ica_matrix_unmixing_row);
            float_matrix_transpose(&ica_matrix_unmixing_row, &ica_matrix_unmixing_row_transpose);
            iter_count++;
        }
        float_matrix_paste_row(&ica_matrix_unmixing_row, p, ica_matrix_unmixing);
    }
    float_matrix_destroy(&ica_matrix_unmixing_row);
    float_matrix_destroy(&g_vector);
    float_matrix_destroy(&gprime_vector);
    float_matrix_destroy(&w_temp);
    float_matrix_destroy(&fun_vector);
    float_matrix_destroy(&ica_matrix_mixed_row);
}
