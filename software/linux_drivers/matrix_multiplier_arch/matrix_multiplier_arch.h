#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>

//AVALON BUS ADDRESS
#define AVALON_LW_ADDRESS_START               (0xFF200000)
#define AVALON_LW_ADDRESS_SPAN                (0x00200000)
#define AVALON_LW_ADRRESS_END  (AVALON_LW_ADDRESS_START-1)

//MATRIX MULTIPLIER ARCHITECTURE ADDRESS
#define MATRIX_MULTIPLIER_ADDR    0x00000000 
#define MATRIX_A_ROWS                      0
#define MATRIX_B_COLS                      1
#define MATRIX_DIM_COMMON                  2
#define RESULTS_TOTAL                      3
#define SHIFT_RESULT                       4
#define MAX_EXPONENT                       5
#define TOTAL_SIZE                         6
#define DATA_READY                         7

typedef volatile unsigned int matrix_multiplier_addr;

typedef struct matrix_multiplier
{
    matrix_multiplier_addr* address;
    uint8_t mac_size;
    uint8_t memory_size;
} matrix_multiplier;

void* avalon_lw_get_virtual_address();
void matrix_multiplier_create(matrix_multiplier* multiplier, uint32_t matrix_multiplier_avalon_address, uint8_t mac_size, uint8_t memory_size);
matrix_multiplier_addr* matrix_multiplier_get_virtual_address(uint32_t matrix_multiplier_avalon_address);
void matrix_multiplier_multiply(float_matrix* matrix_a, float_matrix* matrix_b, float_matrix* matrix_c, matrix_multiplier* multiplier);
void matrix_multiplier_configuration_print(matrix_multiplier* multiplier);

