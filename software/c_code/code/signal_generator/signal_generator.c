#include <signal_generator.h>

void sine_generate(float amplitude, uint16_t frequency, uint16_t sample_frequency, float_matrix* vector_signal)
{
    for(uint32_t i = 0; i < (vector_signal->rows); i++)
    {
        *((vector_signal->address)+i) = (amplitude)*((float) sin(2*M_PI*frequency*(((float) i)/(sample_frequency))));
    }
}

void square_generate(float amplitude, uint16_t frequency, uint16_t sample_frequency, float_matrix* vector_signal)
{
    uint8_t alternator = 0;
    for(uint32_t i = 0; i < (vector_signal->rows); i++)
    {
        *((vector_signal->address)+i) = ((float) sin(2*M_PI*frequency*(i/((float) (sample_frequency))))) > 0 ? 1 : -1; 
    }
}

void sawtooth_generate(float amplitude, uint16_t frequency, uint16_t sample_frequency, float_matrix* vector_signal)
{
    uint8_t sawtooth_dots_per_period = ((uint8_t) ((sample_frequency)/frequency));
    float sawtooth_amplitude = amplitude/sawtooth_dots_per_period;
    float sawtooth = 0;
    for(uint32_t i = 0; i < (vector_signal->rows); i++)
    {
        *((vector_signal->address)+i) = sawtooth;
        sawtooth += sawtooth_amplitude;
        if((i % sawtooth_dots_per_period == 0) && (i != 0))
        {
            sawtooth = 0;
        }
    }
    //float_matrix_print(vector_signal, ',');
}