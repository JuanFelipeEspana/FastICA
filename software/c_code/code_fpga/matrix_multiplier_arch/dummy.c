#include <stdio.h> 
#include <errno.h> 
#include <unistd.h> 
#include <fcntl.h> 
#include <sys/mman.h> 
#include <stdbool.h> 
#include <stdlib.h> 
#include <string.h> 
#include <sys/mman.h> 
#include <inttypes.h>

#define HW_REGS_BASE (0xFF200000) 
#define HW_REGS_SPAN (0x00200000) 
#define HW_REGS_MASK (HW_REGS_SPAN-1) 
#define REG_AVALON_0_BASE 0x00000000

#define MATRIX_MULTIPLIER_ADDR 0x00000000

#define MATRIX_A_ROWS 0 
#define MATRIX_B_COLS 1 
#define MATRIX_DIM_COMMON 2 
#define RESULTS_TOTAL 3 
#define SHIFT_RESULT 4 
#define MAX_EXPONENT 5 
#define TOTAL_SIZE 6 
#define DATA_READY 7 
#define MATRIX_LOADED 8 
#define DATA_COUNTER 9 
#define RESULT_ADDRESS 10 
#define ADDRESS_REG 11 
#define DATA_REG 12 
#define OPERAND_REG 13 
#define OPERAND_CONVERTED 14 
#define ROW_ADDRESS 33 
#define COL_ADDRESS 34

typedef struct int32_matrix {
    uint32_t      rows;
    uint32_t      cols;
    uint8_t     vector;
    int32_t*   address;
} int32_matrix;

typedef struct float_matrix
{
    uint32_t      rows;
    uint32_t      cols;
    uint8_t     vector;
    float*     address;
} float_matrix;


void matrix_multiply_hardware(float_matrix* matrix_A, float_matrix* matrix_B, float_matrix* result_matrix, volatile unsigned int* matrix_multiplier_addr);
void int32_matrix_create(int32_matrix* matrix, uint32_t rows, uint32_t cols);
void int32_matrix_print(int32_matrix* matrix, uint8_t print_type);
void float_matrix_create(float_matrix* matrix, uint32_t rows, uint32_t cols);
void float_matrix_print(float_matrix* matrix);

int main()
{
  int fd;
  void *h2p_virtual_base=NULL;
  volatile unsigned int *h2p_matrix_multiplier_addr=NULL;


  fd=  open("/dev/mem",O_RDWR|O_SYNC);
  if((fd=open("/dev/mem",O_RDWR|O_SYNC))==-1){
    printf("ERROR:Could not open */dev/mem*\n");
    printf(" errno=%s\n",strerror(errno));
    exit(EXIT_FAILURE);
  }

  h2p_virtual_base=mmap(NULL,HW_REGS_SPAN,(PROT_READ|PROT_WRITE),MAP_SHARED,fd,HW_REGS_BASE);
  if(h2p_virtual_base==MAP_FAILED){
    printf("Error:h2p_virtual_base mmap()failed\n");
    printf(" errno=%s\n",strerror(errno));
    close(fd);
    exit(EXIT_FAILURE);
  }

  h2p_matrix_multiplier_addr= (unsigned int*) (h2p_virtual_base + MATRIX_MULTIPLIER_ADDR);
  
  uint32_t matrix_a_rows = 4;
  uint32_t matrix_dim_common = 4;
  uint32_t matrix_b_cols = 4;

  float_matrix matrix_a;
  float_matrix matrix_b;
  float_matrix results;

  float_matrix_create(&matrix_a, matrix_a_rows, matrix_dim_common);
  float_matrix_create(&matrix_b, matrix_dim_common, matrix_b_cols);
  float_matrix_create(&results, matrix_a_rows, matrix_b_cols);
  
  for(uint64_t i = 0; i < ((matrix_a.rows) * (matrix_a.rows)); i++)
    {
      *((matrix_a.address)+i) = 0.0061*(i+1);
      
    }
    
  for(uint64_t i = 0; i < ((matrix_b.rows) * (m int memory_file;trix_b.cols)); i++)
  {
      *((matrix_b.address)+i) = (i+2)*10.56;
  }
  
  printf("MATRIX A\n");
  float_matrix_print(&matrix_a);
  printf("MATRIX B\n");
  float_matrix_print(&matrix_b);
  
  matrix_multiply_hardware(&matrix_a, &matrix_b, &results, h2p_matrix_multiplier_addr);
  
  float_matrix_print(&results);
  
  for(uint64_t i = 0; i < ((matrix_a.rows) * (matrix_a.rows)); i++)
    {
      *((matrix_a.address)+i) = 0.0061*(i+1);
      
    }
    
  for(uint64_t i = 0; i < ((matrix_b.rows) * (matrix_b.cols)); i++)
  {
      *((matrix_b.address)+i) = (i+3)*100;
  }
  matrix_multiply_hardware(&matrix_a, &matrix_b, &results, h2p_matrix_multiplier_addr);
  float_matrix_print(&results);

  close(fd);
  return 0;
}


void matrix_multiply_hardware(float_matrix* matrix_A, float_matrix* matrix_B, float_matrix* result_matrix, volatile unsigned int* matrix_multiplier_addr)
{
  uint64_t total_size = 0;
  uint32_t* current_matrix = 0;
  uint32_t config_regs[5];
  float    only_one_value = 0.0; 

  //-----------REGISTER PRINTING-----------
  config_regs[0] = (matrix_A->rows);
  config_regs[1] = (matrix_B->cols);
  config_regs[2] = (matrix_A->cols);
  config_regs[3] = (matrix_A->rows) * (matrix_B->cols);
  config_regs[4] = -16;
  memcpy((void* ) matrix_multiplier_addr, (void*) &config_regs[0], 5*4);

  //-----------REGISTER PRINTING -----------
  printf("Register MATRIX_A_ROWS has value %u \n", *(matrix_multiplier_addr + MATRIX_A_ROWS));
  printf("Register MATRIX_B_COLS has value %u \n", *(matrix_multiplier_addr + MATRIX_B_COLS));
  printf("Register MATRIX_DIM_COMMON has value %u \n", *(matrix_multiplier_addr + MATRIX_DIM_COMMON));
  printf("Register RESULTS_TOTAL has value %u \n", *(matrix_multiplier_addr + RESULTS_TOTAL));
  printf("Register SHIFT_RESULT has value %u \n", *(matrix_multiplier_addr + SHIFT_RESULT));
  printf("\n");

  //-----------LOADING MATRIX A -----------
  *(matrix_multiplier_addr + MAX_EXPONENT) = -16;
  *(matrix_multiplier_addr + TOTAL_SIZE) = (matrix_A->rows)*(matrix_A->cols);
  memcpy((void* ) (0x10000+matrix_multiplier_addr), (void*) (matrix_A->address), (matrix_A->rows)*(matrix_A->cols)*4);

  //-----------LOADING MATRIX B -----------
  *(matrix_multiplier_addr + MAX_EXPONENT) = 0;
  *(matrix_multiplier_addr + TOTAL_SIZE) = (matrix_B->rows)*(matrix_B->cols);
  memcpy((void* ) (0x10000+matrix_multiplier_addr), (void*) (matrix_B->address), (matrix_B->rows)*(matrix_B->cols)*4);


  //-----------    RESULTS      -----------
  while(*(matrix_multiplier_addr + DATA_READY) == 0);

   memcpy((void *) (result_matrix->address), (void *) (matrix_multiplier_addr+0x30000), ((matrix_A->rows)*(matrix_B->cols))*sizeof(float));
   only_one_value = * (matrix_multiplier_addr + 0x30000 + ((matrix_A->rows)*(matrix_B->cols)));
}

void int32_matrix_create(int32_matrix* matrix, uint32_t rows, uint32_t cols)
{
    (matrix->rows) = rows;
    (matrix->cols) = cols;
    (matrix->vector) = ((rows == 1) || (cols == 1)) ? 1 : 0;
    (matrix->address) = (int32_t* ) malloc((rows*cols) * sizeof(int32_t));
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

void float_matrix_create(float_matrix* matrix, uint32_t rows, uint32_t cols)
{
    (matrix->rows) = rows;
    (matrix->cols) = cols;
    (matrix->vector) = ((rows == 1) || (cols == 1)) ? 1 : 0;
    (matrix->address) = (float* ) malloc((rows*cols) * sizeof(int32_t));
}

void float_matrix_print(float_matrix* matrix)
{
  float value = 0;
  for(uint32_t i = 0; i < (matrix->rows); i++)
  {
      printf("-- ");
      for(uint32_t j = 0; j < (matrix->cols); j++)
      {
          value = *((matrix->address)+((i*(matrix->cols))+j));
          printf("%f",  value);
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
