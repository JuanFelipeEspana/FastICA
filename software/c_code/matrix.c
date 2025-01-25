//        HEADERS
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

//         TYPES
typedef uint8_t        error_t;
//MATRIX
typedef uint16_t matrix_size_t;
typedef float    matrix_data_t;
typedef struct
{
  matrix_data_t*   p_data;
  matrix_size_t   size[2];
  bool         transposed;
  bool          symmetric;
} matrix_t;

//VECTOR        
typedef uint16_t vector_size_t;
typedef float    vector_data_t;
typedef struct
{
  vector_data_t*   p_data;
  vector_size_t      size;
  bool             column;
  bool         transposed;
} vector_t;


//      PROTOTYPES
error_t matrix_create(matrix_t* p_new_matrix, matrix_size_t rows, matrix_size_t cols, matrix_data_t* p_data, bool transposed);
void matrix_free(matrix_t* p_matrix, bool heap);
void matrix_print(matrix_t* p_matrix);
void matrix_transpose(matrix_t* p_matrix);
void matrix_mean(matrix_t* p_matrix, vector_t* mean_vector);
error_t matrix_subs_vector(matrix_t* p_matrix, vector_t* p_vector);
error_t matrix_add_vector(matrix_t* p_matrix, vector_t* p_vector);
vector_t* matrix_copy_vector(matrix_t* p_matrix, matrix_size_t index_row, matrix_size_t index_col, bool column);

error_t vector_create(vector_t* p_new_vector, vector_size_t size, vector_data_t* p_data, bool column);
void vector_free(vector_t* p_vector);
void vector_print(vector_t* p_vector);
void vector_transpose(vector_t* p_vector);
//         MAIN
int main()
{
  matrix_t example_matrix;
  matrix_data_t example_data[] = {1, 9, 12, 1, 3, 19, 2, 3, 2, 7, 7, 1};
  vector_data_t mean_example_matrix_data[4];
  vector_data_t mean_example_matrix_data_t[3];
  
  
  matrix_create(&example_matrix, 3, 4, example_data, 0);
  matrix_print(&example_matrix);
  vector_t mean_example_matrix;
  vector_create(&mean_example_matrix, 4, mean_example_matrix_data, 0);
  matrix_mean(&example_matrix, &mean_example_matrix);
  vector_print(&mean_example_matrix);
  
  matrix_transpose(&example_matrix);
  vector_t mean_example_matrix_t;
  vector_create(&mean_example_matrix_t, 3, mean_example_matrix_data_t, 1);
  matrix_mean(&example_matrix, &mean_example_matrix_t);
  matrix_print(&example_matrix);
  vector_print(&mean_example_matrix_t);
}

error_t matrix_create(matrix_t* p_new_matrix, matrix_size_t rows, matrix_size_t cols, matrix_data_t* p_data, bool transposed)
{
  if ((rows != 0) && (cols != 0))
    {
      //ASSIGN ATTRIBUTES
      p_new_matrix->p_data     = p_data;
      p_new_matrix->size[0]    = rows;
      p_new_matrix->size[1]    = cols;
      p_new_matrix->transposed = transposed;
      p_new_matrix->symmetric  = (rows==cols);

      return 0;
    }
  else
    {
      printf("ERROR matrix_create: one of the size parameters has been set to 0,"
	     "please check function vector_create for allocating vectors.\n");
      return 1;
    }
}

void matrix_free(matrix_t* p_matrix, bool heap)
{
  if(heap)
    {
      //FREE THE SPACE RESERVED FOR DATA
      free(p_matrix->p_data);
    }
  //FREE THE MATRIX STRUCT
  free(p_matrix);

  return;
}

void matrix_print(matrix_t* p_matrix)
{
  register matrix_size_t i, j;
  printf("\n");
  if(p_matrix->transposed)
    {
      for(i = 0; i < (p_matrix->size[1]); ++i)
	{
	  for(j = 0; j < (p_matrix->size[0]); ++j)
	    {
	      printf("%f", *((p_matrix->p_data) + i + (j * (p_matrix->size[1]))));
	      if(j != ((p_matrix->size[0])))
		{
		  printf(" ");
		}
	    }
	    printf("\n");
	}
    }
  else
    {
      for(i = 0; i < (p_matrix->size[0]); ++i)
	{
	  for(j = 0; j < (p_matrix->size[1]); ++j)
	    {
	      printf("%f", *((p_matrix->p_data) + j + (i * (p_matrix->size[1]))));
	      if(j != ((p_matrix->size[0])))
		{
		  printf(" ");
		}
	    }
	    printf("\n");
	}
    }
  printf("\n");
  return;
}

void matrix_transpose(matrix_t* p_matrix)
{
  //CHANGE STATE OF TRANSPOSED
  p_matrix->transposed = !(p_matrix->transposed);
  return;
}

void matrix_mean(matrix_t* p_matrix, vector_t* p_mean_vector)
{
  register matrix_size_t i, j;
  register matrix_data_t acc;
  
  if(p_mean_vector->column)
    {
      for(i = 0; i < (p_matrix->size[0]); ++i)
	{
	  acc = 0;
	  for(j = 0; j < (p_matrix->size[1]); ++j)
	    {
	      acc += *((p_matrix->p_data) + j + (i * (p_matrix->size[1])));
	    }
	  acc = (acc != 0) ? (acc/((matrix_data_t) (p_matrix->size[1]))) : 0;
	  *((p_mean_vector->p_data)+i) = acc;
	}
    }
  else
    {
      for(i = 0; i < (p_matrix->size[1]); ++i)
	{
	  acc = 0;
	  for(j = 0; j < (p_matrix->size[0]); ++j)
	    {
	      acc += *((p_matrix->p_data) + i + (j * (p_matrix->size[1])));
	    }
	  acc = (acc != 0) ? (acc/((matrix_data_t) (p_matrix->size[0]))) : 0;
	  *((p_mean_vector->p_data)+i) = acc;
	}
    }
  return;
}

error_t matrix_subs_vector(matrix_t* p_matrix, vector_t* p_vector)
{
  register matrix_size_t i, j, z;
    
  if (p_vector->column)
    {
      if((p_matrix->size[0]) == (p_vector->size))
	{
	  z = i;
	}
      else
	{
	  printf("ERROR matrix_subs_vector: matrix size in rows doesn't"
		 " match column vector size\n");
	  return 1;
	}
    }
  else
    {
      if((p_matrix->size[1]) == (p_vector->size))
	{
	  z = j;
	}
      else
	{
	  printf("ERROR matrix_subs_vector: matrix size in columns"
		 " doesn't match row vector size\n");
	  return 2;
	}
    }
  for(i = 0; i < (p_matrix->size[0]); ++i)
    {
      for(j = 0; j < (p_matrix->size[1]); ++j)
	{
	  *((p_matrix->p_data) + (i * (p_matrix->size[0])) + j) -= *((p_vector->p_data)+z);
	}
    }

  return 0;
}

error_t matrix_add_vector(matrix_t* p_matrix, vector_t* p_vector)
{
  register matrix_size_t i, j, z;
    
  if (p_vector->column)
    {
      if((p_matrix->size[0]) == (p_vector->size))
	{
	  z = i;
	}
      else
	{
	  printf("ERROR matrix_add_vector: matrix size in rows doesn't"
		 " match column vector size\n");
	  return 1;
	}
    }
  else
    {
      if((p_matrix->size[1]) == (p_vector->size))
	{
	  z = j;
	}
      else
	{
	  printf("ERROR matrix_add_vector: matrix size in columns"
		 " doesn't match row vector size\n");
	  return 2;
	}
    }
  for(i = 0; i < (p_matrix->size[0]); ++i)
    {
      for(j = 0; j < (p_matrix->size[1]); ++j)
	{
	  *((p_matrix->p_data) + (i * (p_matrix->size[0])) + j) += *((p_vector->p_data)+z);
	}
    }

  return 0;
}

/*
vector_t* matrix_copy_vector(matrix_t* p_matrix, matrix_size_t index_row, matrix_size_t index_col, )
{
  matrix_size_t vector_size;
  register matrix_size_t i;
  vector_t* p_copied_vector = 0;
  
  if(p_matrix->transposed)
    {
      if(column)
	{
	  vector_size = (p_matrix->size[0])-(index_row-1);
	  p_copied_vector = vector_create(vector_size, 1);
	  for(i = 0; i < vector_size; ++i)
	    {
	      *((p_copied_vector->p_data)+i) = *((p_matrix->p_data) + ((index_col-1)*(p_matrix->size[0])) + (index_row-1) + i);
	    }
	}
      else
	{
	  vector_size = (p_matrix->size[1])-(index_row-1);
	  p_copied_vector = vector_create(vector_size, 0);
	  for(i = 0; i < vector_size; ++i)
	    {
	      *((p_copied_vector->p_data)+i) = *((p_matrix->p_data) + ((index_col-1)*(p_matrix->size[0])) + (index_row-1) + (i * (p_matrix->size[0])));
	    }
	}
    }
  else
    {
      if(column)
	{
	  vector_size = (p_matrix->size[1])-(index_col-1);
	  p_copied_vector = vector_create(vector_size, 1);
	  for(i = 0; i < vector_size ; ++i)
	    {
	      *((p_copied_vector->p_data)+i) = *((p_matrix->p_data) + ((index_row-1)*(p_matrix->size[0])) + (index_col-1) + (i * (p_matrix->size[0])));
	    }
	}
      else
	{
	  vector_size = (p_matrix->size[0])-(index_col-1);
	  p_copied_vector = vector_create(vector_size, 0);
	  for(i = 0; i < (p_matrix->size[0]); ++i)
	    {
	      *((p_copied_vector->p_data)+i) = *((p_matrix->p_data) + ((index_row-1)*(p_matrix->size[0])) + (index_col-1) + i);
	    }
	}
    }
  return p_copied_vector;
}
*/

//              VECTOR FUNCTIONS

error_t vector_create(vector_t* p_new_vector, vector_size_t size, vector_data_t* p_data, bool column)
{
  if (size != 0)
    {
      p_new_vector->p_data   = p_data;
      p_new_vector->size     = size;
      p_new_vector->column   = column;
      p_new_vector->transposed = 0;
      return 0;
    }
  else
    {
      printf("ERROR vector_create: size parameter has been set to 0\n");
      return 1;
    }
}

void vector_free(vector_t* p_vector)
{
  //FREE VECTOR DATA
  free(p_vector->p_data);
  //FREE VECTOR STRUCT
  free(p_vector);

  return;
}

void vector_print(vector_t* p_vector)
{
  register vector_size_t i;
  printf("\n");
  if(p_vector->column)
    {
      for(i = 0; i < (p_vector->size); ++i)
	{
	  printf("%f", *((p_vector->p_data)+i) );
	  if(i != ((p_vector->size)))
	    {
	      printf("\n");
	    }
	}
    }
  else
    {
      for(i = 0; i < (p_vector->size); ++i)
	{
	  printf("%f", *((p_vector->p_data)+i) );
	  if(i != ((p_vector->size)))
	    {
	      printf(" ");
	    }
	}
    }
  printf("\n");
}

void vector_transpose(vector_t* p_vector)
{
  p_vector->transposed = !(p_vector->transposed);
  p_vector->column     = !(p_vector->column);
  return;
}
