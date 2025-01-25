#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define MACs_num 128

typedef unsigned char uchar;

uchar * bin_to_hex(uchar * bin_number, uchar size);
uchar my_pow(uchar base, uchar exponent);
void print_hexa_array(uchar * number_in_diff_base, uchar size);
void fill_zeros(uchar * number_array, uchar size);

int main() {
    const uchar MACs = MACs_num;
    uchar wr_en[MACs];
    uchar last_wr_en[MACs];
    uchar * hex_wr_en;
    
    uchar start_range;
    bool last_equal = 1;
    bool in_range = 0;
    
    fill_zeros(wr_en, MACs);
    
    for(uchar i = 1; i < MACs; i++)
    {
        last_equal = 1;
        for(uchar j = 0; j < MACs; j++)
        {
            last_wr_en[j] = wr_en[j];
            wr_en[j] = (((j%i)==0) && (i <= (MACs-j))) ? 1 : 0;
            //printf("%d", last_wr_en[j]);
            if(last_wr_en[j] != wr_en[j])
            {
                last_equal = 0;
            }
        }
        //printf("\n");
        
            if((last_equal == 1) && (i != MACs-1))
            {
                if(in_range == 0)
                {
                    in_range = 1;
                    start_range = i-1;
                }
            }
            else
            {
                
                hex_wr_en = bin_to_hex(last_wr_en, MACs);
                print_hexa_array(hex_wr_en, (MACs/4));
                if(in_range == 1){
                    printf(" when ((matrix_dimension<=x\"%02x\")and(matrix_dimension>=x\"%02x\")) else \n", start_range, i);
                    in_range = 0;
                }
                else
                {
                    printf(" when matrix_dimension=x\"%02x\" else \n", i-1);
                }
            }
        
    }
    // Write C code here

    return 0;
}

uchar * bin_to_hex(uchar * bin_number, uchar size)
{
    uchar total_hex_numbers = (size)/4;
    uchar * hex_number = malloc(total_hex_numbers * sizeof(uchar));
    uchar cont_half_bytes = 0;
    uchar acc = 0;
    
    for(uchar i = 0; i <= size; i++)
    {
        if(cont_half_bytes == 4)
        {
            hex_number[((i)/4)-1] = acc;
            acc = 0;
            cont_half_bytes = 0;
        }
        if(i != size)
        {
            acc +=  bin_number[i] * my_pow(2, 3-cont_half_bytes);
            cont_half_bytes ++;
        }
    }
    
    return hex_number;
}

void print_hexa_array(uchar * number_in_diff_base, uchar size)
{
    printf("x\"");
    for(uchar i = 0; i < size; i++)
    {
        printf("%x", number_in_diff_base[i]);
    }
    printf("\"");
}

void fill_zeros(uchar * number_array, uchar size)
{
    for(uchar i = 0; i < size; i++)
    {
        number_array[i] = 0;
    }
}

uchar my_pow(uchar base, uchar exponent)
{
    uchar acc = 1;
    for(uchar i = 0; i < exponent; i++)
    {
        acc = acc * base;
    }
    
    return acc;
}
