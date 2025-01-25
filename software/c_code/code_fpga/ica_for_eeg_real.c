#include <matrix.h>
#include <signal_generator.h>
#include <ica.h>

int main()
{
    srand(time(NULL));
    uint8_t  ica_signals =    3;
    uint16_t ica_samples = 1000;
    
    float_matrix matrix_original_signals;
    float_matrix_create(&matrix_original_signals, ica_samples, ica_signals);
    float_matrix sine_signal;
    float_matrix_create(&sine_signal, ica_samples, 1);
    float_matrix square_signal;
    float_matrix_create(&square_signal, ica_samples, 1);
    float_matrix sawtooth_signal;
    float_matrix_create(&sawtooth_signal, ica_samples, 1);

    float_matrix ica_matrix_mixing;
    float_matrix_create(&ica_matrix_mixing, ica_signals, ica_signals);
    float_matrix ica_matrix_mixed;
    float_matrix_create(&ica_matrix_mixed, ica_samples, ica_signals);
    float_matrix ica_matrix_mixed_whitened;
    float_matrix_create(&ica_matrix_mixed_whitened, ica_samples, ica_signals);
    float_matrix ica_matrix_unmixing;
    float_matrix_create(&ica_matrix_unmixing, ica_signals, ica_signals);
    float_matrix ica_matrix_unmixing_transpose;
    float_matrix_create(&ica_matrix_unmixing_transpose, ica_signals, ica_signals);
    float_matrix ica_matrix_unmixed;
    float_matrix_create(&ica_matrix_unmixed, ica_samples, ica_signals);
    float_matrix ica_all_stages;
    float_matrix_create(&ica_all_stages, ica_samples, ica_signals*3);

    sine_generate(1, 20, &sine_signal);
    square_generate(1, 20, &square_signal);
    sawtooth_generate(1, 20, &sawtooth_signal);
    float_matrix_paste_col(&sine_signal, 0, &matrix_original_signals);
    float_matrix_paste_col(&square_signal, 1, &matrix_original_signals);
    float_matrix_paste_col(&sawtooth_signal, 2, &matrix_original_signals);
    //float_matrix_print(&matrix_original_signals, ';');
    
    *((ica_matrix_mixing.address)) = 0.5;
    *((ica_matrix_mixing.address)+1) = -0.2;
    *((ica_matrix_mixing.address)+2) = -0.3;
    *((ica_matrix_mixing.address)+3) = 0.5;
    *((ica_matrix_mixing.address)+4) = -0.5;
    *((ica_matrix_mixing.address)+5) = 0.6;
    *((ica_matrix_mixing.address)+6) = 0.9;
    *((ica_matrix_mixing.address)+7) = -0.1;
    *((ica_matrix_mixing.address)+8) = 0.1;
    //float_matrix_multiply_scalar(&ica_matrix_mixing, (1.0/1000), &ica_matrix_mixing);
    
    
    float_matrix_multiply(&matrix_original_signals, &ica_matrix_mixing, &ica_matrix_mixed);
    //float_matrix_print(&ica_matrix_mixed, ';');
    ica_whiten(&ica_matrix_mixed, &ica_matrix_mixed_whitened);
    
    *((ica_matrix_unmixing.address)) = 1;
    *((ica_matrix_unmixing.address)+1) = 2;
    *((ica_matrix_unmixing.address)+2) = 3;
    *((ica_matrix_unmixing.address)+3) = 0;
    *((ica_matrix_unmixing.address)+4) = 7;
    *((ica_matrix_unmixing.address)+5) = -9;
    *((ica_matrix_unmixing.address)+6) =-8;
    *((ica_matrix_unmixing.address)+7) = 0;
    *((ica_matrix_unmixing.address)+8) = 2;
    ica_calculate_matrix_unmixing(&ica_matrix_mixed_whitened, ica_samples, ica_signals, &ica_matrix_unmixing, 0.0000000001, 500000, 1);
    float_matrix_print(&ica_matrix_unmixing, ';');
    float_matrix_transpose(&ica_matrix_unmixing, &ica_matrix_unmixing_transpose);
    float_matrix_multiply(&ica_matrix_mixed_whitened, &ica_matrix_unmixing_transpose, &ica_matrix_unmixed);
    float_matrix_print(&ica_matrix_unmixed, ';');    
    
}