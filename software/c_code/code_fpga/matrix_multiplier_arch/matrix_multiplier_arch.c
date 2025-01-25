#include <matrix_multiplier_arch.h>

void* avalon_lw_get_virtual_address(int memory_file)
{
    void* avalon_lightweight = NULL;
    matrix_multiplier_addr* matrix_multiplier_address = NULL;

    //OPEN SYSTEM MEMORY FILE
    memory_file = open("/dev/mem", O_RDWR|O_SYNC);
    if(memory_file == -1)
    {
        printf("ERROR: Memory file couldn't be open, contact the programmer. \n");
        //printf("errno = %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }

    //MAP SYSTEM MEMORY FILE TO FIND AVALON LIGHTWEIGHT VIRTUAL ADDRESS (DIFFERENT THAN PHYSIC ADDRESS)
    avalon_lightweight = mmap(NULL, AVALON_LW_ADDRESS_SPAN, (PROT_READ|PROT_WRITE), MAP_SHARED, memory_file, AVALON_LW_ADDRESS_START);
    if(avalon_lightweight == MAP_FAILED)
    {
        printf("ERROR: Avalon lightweight bus couldn't be mapped, contact the programmer.\n");
        //printf("errno = %s\n", strerror(errno));
        close(memory_file);
        exit(EXIT_FAILURE);
    }

    return avalon_lightweight;
}

void matrix_multiplier_create(matrix_multiplier* multiplier, uint32_t matrix_multiplier_avalon_address, uint8_t mac_size, uint8_t memory_size, int memory_file)
{
    //FILL ATTRIBUTES OF MATRIX MULTIPLIER
    (multiplier->address) = matrix_multiplier_get_virtual_address(matrix_multiplier_avalon_address, memory_file);
    (multiplier->mac_size) = mac_size;
    (multiplier->memory_size) = memory_size;
}


matrix_multiplier_addr* matrix_multiplier_get_virtual_address(uint32_t matrix_multiplier_avalon_address, int memory_file)
{

    //ADD MATRIX MULTIPLIER OFFSET
    matrix_multiplier_addr* matrix_multiplier_address  = (matrix_multiplier_addr* )  (avalon_lw_get_virtual_address(memory_file) + matrix_multiplier_avalon_address);

    return matrix_multiplier_address;
}

void matrix_multiplier_multiply(float_matrix* matrix_a, float_matrix* matrix_b, matrix_multiplier* multiplier)
{
    //FIND ARCHITECTURE ADDRESS SIZE
    uint8_t matrix_multiplier_address_size = ((multiplier->mac_size) + (multiplier->memory_size)) - 1;
    uint32_t matrix_multiplier_address_write_offset = (0x1 << matrix_multiplier_address_size);

    //SHIFTS TO AVOID OVERFLOW
    uint8_t product_shift_preventive = matrix_multiplier_find_shift(matrix_a, multiplier);

    //CONFIGURATION REGISTERS
    uint32_t config_regs[5];    
    //OPERATION SPECIFIC REGISTERS
    config_regs[0] = (matrix_a->rows);
    config_regs[1] = (matrix_b->cols);
    config_regs[2] = (matrix_a->cols);
    config_regs[3] = (matrix_a->rows) * (matrix_b->cols);
    config_regs[4] = (matrix_a->max_exponent) + (matrix_b->max_exponent) + (2*product_shift_preventive);
    memcpy((void*) (multiplier->address), (void*) &config_regs[0], 5*sizeof(uint32_t));
    
    //MATRIX A REGISTERS
    *((multiplier->address) + MAX_EXPONENT) = (matrix_a->max_exponent) + product_shift_preventive;
    *((multiplier->address) + TOTAL_SIZE) = (matrix_a->rows)*(matrix_a->cols);
    //MATRIX A VALUES
    memcpy((void* ) ((multiplier->address) + (matrix_multiplier_address_write_offset)), (void*) (matrix_a->address), (matrix_a->rows)*(matrix_a->cols)*sizeof(float));
    
    //MATRIX B REGISTERS
    *((multiplier->address) + MAX_EXPONENT) = (matrix_b->max_exponent) + product_shift_preventive;
    *((multiplier->address) + TOTAL_SIZE) = (matrix_b->rows)*(matrix_b->cols);
    //MATRIX B VALUES
    memcpy((void* ) ((multiplier->address) + (matrix_multiplier_address_write_offset)), (void*) (matrix_b->address), (matrix_b->rows)*(matrix_b->cols)*sizeof(float));
}

uint8_t matrix_multiplier_multiply_done(matrix_multiplier* multiplier)
{
    return (*((multiplier->address) + DATA_READY));
}

void matrix_multiplier_get_result(float_matrix* matrix_results, matrix_multiplier* multiplier)
{
    float unusable = 0.0;
    //FIND RESULTS SIZE FROM HARDWARE
    uint32_t matrix_results_rows_hw = *((multiplier->address) + MATRIX_A_ROWS);
    uint32_t matrix_results_cols_hw = *((multiplier->address) + MATRIX_B_COLS);

    //FIND ARCHITECTURE ADDRESS SIZE
    uint8_t matrix_multiplier_address_size = ((multiplier->mac_size) + (multiplier->memory_size)) - 1;
    uint32_t matrix_multiplier_address_read_offset = (0x3 << matrix_multiplier_address_size);

    if(((matrix_results->rows) != (matrix_results_rows_hw)) || ((matrix_results->rows) != (matrix_results_cols_hw)))
    {
        printf("ERROR: matrix to store results doesn't match with multiplication done in hardware, so nothing was done. \n");
        return ;
    }

    //COPY RESULTS FROM ARCHITECTURE TO MATRIX IN MAIN MEMORY
    memcpy((void* ) (matrix_results->address), (void* ) ((multiplier->address) + (matrix_multiplier_address_read_offset)), ((matrix_results->rows)*(matrix_results->cols))*sizeof(float));
    unusable = *((multiplier->address) + matrix_multiplier_address_read_offset + ((matrix_results_rows_hw)*(matrix_results_cols_hw)));
}

void matrix_multiplier_configuration_print(matrix_multiplier* multiplier)
{
    //PRINT INFO SET IN ALL OPERATION REGISTERS
    printf("Register MATRIX_A_ROWS has value %u \n", *((multiplier->address) + MATRIX_A_ROWS));
    printf("Register MATRIX_B_COLS has value %u \n", *((multiplier->address) + MATRIX_B_COLS));
    printf("Register MATRIX_DIM_COMMON has value %u \n", *((multiplier->address) + MATRIX_DIM_COMMON));
    printf("Register RESULTS_TOTAL has value %u \n", *((multiplier->address) + RESULTS_TOTAL));
    printf("Register SHIFT_RESULT has value %u \n", *((multiplier->address) + SHIFT_RESULT));
    printf("\n");
}

uint8_t matrix_multiplier_find_shift(float_matrix* matrix_a, matrix_multiplier* multiplier)
{
    uint8_t shift = 0;
    for(uint8_t i = 1; i <= (multiplier->memory_size); i++)
    {
        if(number_in_range((matrix_a->cols), (1 << (i-1)), (1 << (i))))
        {
            shift = i-1;
        }
    }
    return shift;
}

uint8_t number_in_range(uint32_t number, uint32_t range_low, uint32_t range_top)
{
    if((range_low <= number) && (number <= range_top))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

void matrix_multiplier_destroy(int file)
{
    close(file);
}
