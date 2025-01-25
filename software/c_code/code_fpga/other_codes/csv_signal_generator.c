#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <matrix.h>
#include <ica.h>
#include <signal_generator.h>
#include <matrix_multiplier_arch.h>


#define MAX_COLS = 100;
#define MAX_ROWS = 100;


int main()
{
    FILE* signals_data = fopen("signals_data.csv", "w");

    uint16_t signals_num_samples = (1024*50);
    float_matrix sine_signal;
    float_matrix_create(&sine_signal, signals_num_samples, 1);
    float_matrix square_signal;
    float_matrix_create(&square_signal, signals_num_samples, 1);
    float_matrix sawtooth_signal;
    float_matrix_create(&sawtooth_signal, signals_num_samples, 1);
    float_matrix signals;
    float_matrix_create(&signals, signals_num_samples, 3);
    float_matrix ica_mixing_matrix;
    float_matrix_create(&ica_mixing_matrix, 3, 3);
    float_matrix ica_mixed_matrix;
    float_matrix_create(&ica_mixed_matrix, signals_num_samples, 3);


    sine_generate(1, 20, 1024, &sine_signal);
    square_generate(1, 20, 1024, &square_signal);
    sawtooth_generate(1, 20, 1024, &sawtooth_signal);
    float_matrix_fill_random(&ica_mixing_matrix, 20);
    float_matrix_multiply_scalar(&ica_mixing_matrix, 0.05, &ica_mixing_matrix);

    float_matrix_paste_col(&sine_signal, 0, &signals);
    float_matrix_paste_col(&square_signal, 1, &signals);
    float_matrix_paste_col(&sawtooth_signal, 2, &signals);
    
    float_matrix_multiply(&signals, &ica_mixing_matrix, &ica_mixed_matrix);

    float_matrix_print(&ica_mixing_matrix, ';');
    float_matrix_print_file(&ica_mixed_matrix, ';', signals_data);
    fclose(signals_data);
    

    return 1;
}
