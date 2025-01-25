#include <matrix_multiplier_arch.h>

void* avalon_lw_get_virtual_address()
{
    int memory_file;
    void* avalon_lightweight = NULL;
    matrix_multiplier_addr* matrix_multiplier_address = NULL;

    //OPEN SYSTEM MEMORY FILE
    memory_file = open("/dev/mem", O_RDWR|O_SYNC);
        if((memory_file = open("/dev/mem", O_RDWR|O_SYNC)) == -1){
        printf("ERROR: Memory file couldn't be open, contact the programmer. \n");
        //printf("errno = %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }

    //MAP SYSTEM MEMORY FILE TO FIND AVALON LIGHTWEIGHT VIRTUAL ADDRESS (DIFFERENT THAN PHYSIC ADDRESS)
    avalon_lightweight = mmap(NULL, AVALON_LW_ADDRESS_SPAN, (PROT_READ|PROT_WRITE), MAP_SHARED, memory_file, AVALON_LW_ADDRESS_START);
    if(avalon_lightweight == MAP_FAILED){
        printf("ERROR: Avalon lightweight bus couldn't be mapped, contact the programmer.\n");
        //printf("errno = %s\n", strerror(errno));
        close(memory_file);
        exit(EXIT_FAILURE);
    }

    //CLOSE SYSTEM MEMORY FILE
    close(memory_file);

    return avalon_lightweight;
}

void matrix_multiplier_create(matrix_multiplier* multiplier, uint32_t matrix_multiplier_avalon_address, uint8_t mac_size, uint8_t memory_size)
{
    //FILL ATTRIBUTES OF MATRIX MULTIPLIER
    (multiplier->address) = matrix_multiplier_get_virtual_address(matrix_multiplier_avalon_address);
    (multiplier->mac_size) = mac_size;
    (multiplier->memory_size) = memory_size;
}


matrix_multiplier_addr* matrix_multiplier_get_virtual_address(uint32_t matrix_multiplier_avalon_address)
{

    //ADD MATRIX MULTIPLIER OFFSET
    matrix_multiplier_addr* matrix_multiplier_address  = (matrix_multiplier_addr*) (avalon_lw_get_virtual_address() + matrix_multiplier_avalon_address);

    return matrix_multiplier_address;
}

void matrix_multiplier_multiply(float_matrix* matrix_a, float_matrix* matrix_b, float_matrix* matrix_c, matrix_multiplier* multiplier)
{
    //FIND ARCHITECTURE ADDRESS SIZE
    uint8_t matrix_multiplier_address_size = ((multiplier->mac_size) + (multiplier->memory_size)) - 1;

    //CONFIGURATION REGISTERS
    uint32_t config_regs[5];
    //OPERATION SPECIFIC REGISTERS
    config_regs[0] = (matrix_a->rows);
    config_regs[1] = (matrix_b->cols);
    config_regs[2] = (matrix_a->cols);
    config_regs[3] = (matrix_a->rows) * (matrix_b->cols);
    config_regs[4] = (matrix_a->max_exponent) + (matrix_b->max_exponent);
    memcpy((void*) (multiplier->address), (void*) &config_regs[0], 5*sizeof(uint32_t));
    
    //MATRIX A REGISTERS
    *((multiplier->address) + MAX_EXPONENT) = (matrix_a->max_exponent);
    *((multiplier->address) + TOTAL_SIZE) = (matrix_a->rows)*(matrix_a->cols);
    //MATRIX A VALUES
    memcpy((void* ) ((multiplier->address) + (0x1 << matrix_multiplier_address_size)), (void*) (matrix_a->address), (matrix_a->rows)*(matrix_a->cols)*sizeof(float));
    
    //MATRIX B REGISTERS
    *((multiplier->address) + MAX_EXPONENT) = (matrix_b->max_exponent);
    *((multiplier->address) + TOTAL_SIZE) = (matrix_b->rows)*(matrix_b->cols);
    //MATRIX B VALUES
    memcpy((void* ) ((multiplier->address) + (0x1 << matrix_multiplier_address_size)), (void*) (matrix_b->address), (matrix_b->rows)*(matrix_b->cols)*sizeof(float));

    //WAIT TILL DATA IS READY
    while(*((multiplier->address) + DATA_READY) == 0);

    //COPY RESULTS FROM ARCHITECTURE TO MATRIX IN MAIN MEMORY
    memcpy((void* ) (matrix_c->address), (void* ) ((multiplier->address) + (0x3 << matrix_multiplier_address_size)), ((matrix_a->rows)*(matrix_b->cols))*sizeof(float));
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
