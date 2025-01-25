#include <matrix.h>
#include <ica.h>
#include <signal_generator.h>
#include <matrix_multiplier_arch.h>
#include <time.h>

#define MAX_16BIT 65355
#define MAX_MACS 128
#define MAX_MAC_SIZE 1024
#define MIN_RANGE -18
#define MAX_RANGE 40
#define MATRIX_TEST 1000

void error_calculate_matrix(float_matrix* software_matrix, float_matrix* hardware_matrix, float_matrix* error_matrix){
    //error_matrix[3] = max_error, min_error, prom_error
    //posicion de la matriz resultado es y asi poder luego saber de que producto se origina
    float error= 100 * fabs((*(software_matrix->address) - *(hardware_matrix->address))/ (*(software_matrix->address) == 0.0 ? 1.0 : *(software_matrix->address)));
    *error_matrix->address=error;//max_error
    *(error_matrix->address +1)=error;//min_error
    *(error_matrix->address +2)=0.0;//prom_error
    for (int i=0;i<software_matrix->rows;i++){
        for (int j=0;j<software_matrix->cols;j++){
            error = 100 * fabs(( *(software_matrix->address + i*software_matrix->cols + j) - *(hardware_matrix->address + i*software_matrix->cols + j) ) / (*(software_matrix->address + i*software_matrix->cols + j)==0.0 ? 1.0 : *(software_matrix->address + i*software_matrix->cols + j)) );
            if(error > *(error_matrix->address)){
                *error_matrix->address=error;
            }
            else if(error < *(error_matrix->address +1)){
                *(error_matrix->address +1)=error;
            }
            *(error_matrix->address + 2) += (error/(software_matrix->rows*software_matrix->cols));
        }
    }
}

void random_Matrix_generate(float_matrix* matrix,uint32_t rows, uint32_t cols, double max_range){
    for (uint32_t i=0;i<rows;i++){
        for(uint32_t j=0;j<cols;j++){
            float random_number = ((float)random_number_generate( (65365) )) * (float)pow(2.0, max_range - 16.0);
            *(matrix->address+i*matrix->cols+j)=random_number;
        }
    }
}

int main()
{
    srand(time(NULL));

    /*
    matrix_multiplier multiplier1;
    matrix_multiplier_create(&multiplier1, 0, 7, 10);
    */
    uint8_t matrix_a_rows = 3;
    
    float_matrix matrix_a;
    float_matrix_create(&matrix_a, 3, 3);
    float_matrix matrix_b;
    float_matrix_create(&matrix_b, 3, 3);
    float_matrix matrix_c_hw;
    float_matrix_create(&matrix_c_hw, 3, 3);
    float_matrix matrix_c_sw;
    float_matrix_create(&matrix_c_sw, 3, 3);
    float_matrix error;
    float_matrix_create(&error, 1, 3);

    random_Matrix_generate(&matrix_a, 3, 3, 16);
    matrix_a.max_exponent = 0;
    random_Matrix_generate(&matrix_a, 3, 3, 8);
    matrix_b.max_exponent = -8;

    /*
    matrix_multiplier_multiply(&matrix_a, &matrix_b, &matrix_c_hw, &multiplier1);
    */
    float_matrix_multiply(&matrix_a, &matrix_b, &matrix_c_hw);

    error_calculate_matrix(&matrix_c_sw, &matrix_c_hw, &error);

    float_matrix_print(&matrix_c_sw, ';');
    float_matrix_print(&matrix_c_hw, ';');
    float_matrix_print(&error, ';');

}