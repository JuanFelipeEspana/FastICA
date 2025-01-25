#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>
#include <math.h>
#include <time.h>
#include <lapacke.h>

//CONSTANTES de JFE
#define N            3
#define N_SAMPLES 1000
#define RES         16

//FUNCIONES DE JAIRO
void transpose(double** w, unsigned int row_size, unsigned int column_size, double** transposed);
void rand_vector(unsigned int seed, double *vector, int vector_size);
void normalize_vector(double *vector, int length, double *result);
double dotProduct_unrolled(double *vec_1, double *vec_2, int length);
void matrixVectorProductUnrolled(double **matrix, double *vector, int numRows, int numCols, double *result);
double g_fun(double *z, double *wp, int function, int length);
double gprime_fun(double *z, double *wp, int function, int length);
void sum_vectors (double *vec_1, double *vec_2, int length, double *result);
void substract_vectors (double *vec_1, double *vec_2, int length, double *result);
void def_orthogonalization(double *wp,int iteration, double **w, int vector_size, double *result);
void scalar_multiply(double scalar, double *vector, double *result, int length);
double copy(double *copy_vector, double *original_vector, int size);
void zeros(double* vector, int length);
void MaxtrixGeneration(double **z_array, int number_samples, int m, double **w_matrix, double tol,int max_iter, int function);

//FUNCIONES JFE
double **createMatrix(int size);
double **createAsymmetricMatrix(int rows, int cols);
void freeMatrix(double **targetMatrix, int size);
void freeAsymmetricMatrix(double **targetMatrix, int rows);
double *createVector(int size);
void printMatrix(double **targetMatrix, int rows, int cols);
void printInverseMatrix(double **targetMatrix, int rows, int cols);
void printVector(double *targetVector, int size);
double *meanMatrix(double **targetMatrix, int rows, int cols);
double **vectorSubsMatrix(double *vector, double **targetMatrix, int rows, int cols);
double **transposeMatrix(double **targetMatrix, int rows, int cols);
double **matrixProduct(double **matrix1, double **matrix2, int size);
double **asymmetricMatrixProduct(double **matrix1, int rows1, int cols1, double **matrix2, int rows2, int cols2);
double **scalarMatrixSubs(double scalar, double **targetMatrix, int size);
double **scalarMatrixProduct(double scalar, double **targetMatrix, int size);
double *unfoldMatrix(double **targetMatrix, int rows, int cols);
double **foldVector(double *vector, int size);
double **foldAsymmetricVector(double *vector, int rows, int cols);
double **eigenValues(double **targetMatrix, int size);
double **eigenVectors(double **targetMatrix, int size);
double **inverseDiagMatrix(double **targetMatrix, int size);
double *inverseVector(double *vector, int size);
double **sqrtElementMatrix(double **targetMatrix, int size);
double **generateRandomMatrix(int limit, int size);
double **generateSines(int numSines, int samples, int minCycles);
double **randomMixing(double **originalSources, int rows, int cols);
void printCSV(double ***matrix, int numMatrix, int rows, int cols);
double *cpyRowMatrix(double **targetMatrix, int row, int cols);
double *signVector(double *vector, int size);
double **vectorMatrixProduct(double *vector, double **targetMatrix, int rows, int cols);
double **whiten(double **originalMatrix, int rows, int cols);
double ***svdDecomposition(double **targetMatrix, int rows, int cols);
double **unmixingMatrix(double **mixedSources, double **unmixMatrix, int rows, int cols);

//TEST FUNCTIONS
uint32_t decimal_float32_to_sign_magnitude_integer16(float number);
char* sign_magnitude_integer16_to_binary(uint32_t number);
float sign_magnitude_integer16_to_float(uint32_t number);
void matrix_format(double **unmix_matrix, int cols);

//MAIN

int main(){
    double **realData;
    double **mixedData;
    double **whitenedData;
    double **whitenedDataTranspose;
    double **W;
    double **estimationTranspose;
    double **estimation;
    double wData[] = {1,2,3,0,7,-9,-8,0,2};
    int realSamples = N*((int) N_SAMPLES/N);
    
    srand(time(NULL));
    realData = generateSines(N, N_SAMPLES, 10); //ORIGINAL SINE WAVES
    mixedData = randomMixing(realData, N_SAMPLES, N); //MIXED SINE WAVES
    whitenedData = whiten(mixedData, realSamples, N); //WHITENED SINES
    whitenedDataTranspose = transposeMatrix(whitenedData, realSamples, N);
    W = foldVector(wData, N);
    MaxtrixGeneration(whitenedData,realSamples,N,W,0.0000000001,500000,1); //UNMIXING MATRIX
    printMatrix(W, N, N);
    matrix_format(W, N);
    printMatrix(W, N, N);
    estimationTranspose = asymmetricMatrixProduct(W, N, N, whitenedDataTranspose, N, realSamples);
    estimation = transposeMatrix(estimationTranspose, N, realSamples);
    double **matrixPrintables[] = {realData,mixedData, whitenedData, estimation};
    printCSV(matrixPrintables,4,realSamples,N);

    freeAsymmetricMatrix(whitenedDataTranspose, N);
    freeAsymmetricMatrix(estimationTranspose, N);
    freeAsymmetricMatrix(realData, N_SAMPLES);
    freeAsymmetricMatrix(mixedData, realSamples);
    freeAsymmetricMatrix(whitenedData,realSamples);
    freeMatrix(W, N);
    freeAsymmetricMatrix(estimation, realSamples);
    return 0;
}


//m=number_ICs
void MaxtrixGeneration(double **z_array, int number_samples, int m, double **w_matrix, double tol,int max_iter, int function){
    double wp[m];
    double g_vector[m],gprime_vector[m], w_temp[m], fun_vector[m];
    double mean_scalar, convergence_difference;
    int iter_count;
    unsigned int seed = (unsigned)time(NULL); 
    for(int p=0;p<m;p++){
        rand_vector(seed, wp, m); 
        //printf("wp es %f %f %f\n",*(wp),*(wp+1),*(wp+2));
        seed++;
        convergence_difference= tol+1; 
        iter_count=0; 
        double *a=(double *)(z_array);
            while( iter_count<max_iter && convergence_difference > tol ){
                zeros(g_vector,m);
                mean_scalar=0;
                for (int i=0;i<number_samples;i++){
                    scalar_multiply(g_fun(*(z_array+i),wp,function,m)*((double)1/number_samples), *(z_array+i),fun_vector,m);
                    //printf("wp es %f %f %f\n",*(wp),*(wp+1),*(wp+2));
                    //printf("fun es %f %f %f\n",*(fun_vector),*(fun_vector+1),*(fun_vector+2));
                    //printf("g_vector antes %f %f %f\n",*(g_vector),*(g_vector+1),*(g_vector+2));
                    sum_vectors(g_vector,fun_vector,m,g_vector);
                    //printf("g_vector despues %f %f %f\n",*(g_vector),*(g_vector+1),*(g_vector+2));
                    mean_scalar=mean_scalar+(gprime_fun(*(z_array+i),wp,function,m))*((double)1/number_samples);
                    //printf("mean_scalar es %f\n",mean_scalar);
                }
                scalar_multiply(mean_scalar,wp,gprime_vector,m);
                //printf("g_prime es %f %f %f\n",*(gprime_vector),*(gprime_vector+1),*(gprime_vector+2));
                substract_vectors(g_vector,gprime_vector,m,w_temp);
                //printf("w_temp es %f %f %f\n",*(w_temp),*(w_temp+1),*(w_temp+2));
                //printf("p es %i\n",p);
                def_orthogonalization(w_temp,p,w_matrix,m,w_temp);
                normalize_vector(w_temp,m,w_temp);
                //printf("w_temp normal es %f %f %f\n",*(w_temp),*(w_temp+1),*(w_temp+2));
                convergence_difference=fabs(fabs(dotProduct_unrolled(wp,w_temp,m))-1);
                copy(wp,w_temp,m);
                //printf("El iter es %d\n",iter_count);
                //printf("El error es %f\n",convergence_difference);
                iter_count++;
            }
	    //copy(*(w_matrix+p),wp,m);
	    scalar_multiply(1, wp,*(w_matrix+p),m);
        //printf("el w_matrix es %f %f %f\n",*(*(w_matrix+p)),*(*(w_matrix+p)+1), *(*(w_matrix+p)+2));  
    } 
}
void rand_vector(unsigned int seed, double *vector, int vector_size){
    srand(seed);
   for (int i=0; i < vector_size; i++ ){
       *(vector+i)= ((double)rand() / RAND_MAX)*2 - 1;
    }  
    normalize_vector(vector,vector_size,vector);
}
void normalize_vector(double *vector, int length, double *result){
    double magnitude=sqrt(dotProduct_unrolled(vector,vector,length));
    for (int i=0;i<length;i++){
        result[i]=vector[i]/magnitude;
    }
}
double dotProduct_unrolled(double *vec_1, double *vec_2, int length){
    int i=0;
    double result=0;
     // Unrolling el loop, procesando 5 elementos a la vez
    for (i = 0; i < length - 4; i += 5) {
        result += vec_1[i] * vec_2[i];
        result += vec_1[i + 1] * vec_2[i + 1];
        result += vec_1[i + 2] * vec_2[i + 2];
        result += vec_1[i + 3] * vec_2[i + 3];
        result += vec_1[i + 4] * vec_2[i + 4];
    }
    // Procesar los elementos restantes
    for (; i < length; i++) {
        result += vec_1[i] * vec_2[i];
    }
    return result;

}
void matrixVectorProductUnrolled(double **matrix, double *vector, int numRows, int numCols, double *result) {
    for (int i = 0; i < numRows; i++) {
       result[i] = dotProduct_unrolled( (double *)(matrix+numCols*i), vector, numCols);
    }
}
void transpose(double** w, unsigned int row_size, unsigned int column_size, double** transposed) {
   for (int i = 0; i < column_size; i++) {
        transposed[i] = (double*)malloc(row_size * sizeof(double));
    }

    for (int i = 0; i < row_size; i++) {
        for (int j = 0; j < column_size; j++) {
            transposed[j][i] = w[i][j];
        }
    }
}
void zeros(double* vector, int length){
    for (int i=0;i<length;i++)
        *(vector+i)=0;
}
void scalar_multiply(double scalar, double *vector, double *result, int length){
    for(int i=0;i<length;i++)
        result[i]=scalar * vector[i];
}
void def_orthogonalization(double *wp,int iteration, double **w, int vector_size, double *result){
    double sum[vector_size];
    double w_product[vector_size];
    zeros(sum,vector_size);
    for (int k=0;k<iteration;k++){
        scalar_multiply(dotProduct_unrolled(wp,*(w+k),vector_size),*(w+k),w_product,vector_size);
        //printf("k es %i, el wp es %f %f %f\n",k,*wp,*(wp+1),*(wp+2));
        //printf("el wj es %f %f %f\n",*(*(w+k)),*(*(w+k)+1), *(*(w+k)+2));
        sum_vectors(sum,w_product,vector_size, sum);
    }
    substract_vectors(wp,sum,vector_size,result);
}
void sum_vectors (double *vec_1, double *vec_2, int length, double *result){
    for (int i=0;i<length;i++){
        result[i]=vec_1[i]+vec_2[i];
    }
}
void substract_vectors (double *vec_1, double *vec_2, int length, double *result){
    for (int i=0;i<length;i++){
        result[i]=vec_1[i]-vec_2[i];
    }
}
double g_fun(double *z, double *wp, int function, int length){
    double y, result;
    y=dotProduct_unrolled(wp,z,length);
    if(function==1)
        result=tanh(y);
    else if(function==2)
        result=y*exp(-pow(y,2)*0.5);
    else
        result=pow(y,3);
    return result;
}
double gprime_fun(double *z, double *wp, int function, int length){
    double y, result;
    y=dotProduct_unrolled(wp,z,length);
    if(function==1)
        result=1-pow(tanh(y),2);
    else if(function==2)
        result=(1-pow(y,2))*exp(-pow(y,2)*0.5);
    else
        result=3*pow(y,2);
    return result;
}
double copy(double *copy_vector, double *original_vector, int size){
    for(int j=0;j<size;j++)
        copy_vector[j]=original_vector[j];
}

double **createMatrix(int size){
  double **address;
  address = (double **) malloc(size * sizeof(double *));
  for(int i = 0; i < size; i++){
    address[i] = (double *) malloc(size * sizeof(double));
  }
  return address;
}

double **createAsymmetricMatrix(int rows, int cols){
  double **address;
  address = (double**) malloc(rows * sizeof(double *));
  for(int i = 0; i < rows; i++){
    address[i] = (double *) malloc(cols * sizeof(double));
  }
  return address;
}

void freeMatrix(double **targetMatrix, int size){
  for(int i = 0; i < size; i++){
    free(targetMatrix[i]);
  }
  free(targetMatrix);
}

void freeAsymmetricMatrix(double **targetMatrix, int rows){
  for(int i = 0; i < rows; i++){
    free(targetMatrix[i]);
  }
  free(targetMatrix);
}

double *createVector(int size){
  double *vector;
  vector = (double *) malloc(size * sizeof(double));
  return vector;
}

void printMatrix(double **targetMatrix, int rows, int cols){
  printf("\n");
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      printf("%f ", targetMatrix[row][col]);
    }
    printf("\n");
  }
  printf("\n");
}

void printInverseMatrix(double **targetMatrix, int rows, int cols){
  printf("\n");
  for(int col = 0; col < cols; col++){
    for(int row = 0; row < rows; row++){
      printf("%f ", targetMatrix[row][col]);
    }
    printf("\n");
  }
  printf("\n");
}

void printVector(double *targetVector, int size){
  printf("\n");
  for(int i = 0; i < size; i++){
    printf("%f ", targetVector[i]);
  }
  printf("\n");
}

double *meanMatrix(double **targetMatrix, int rows, int cols){
  double *mean;
  mean = createVector(cols);
  for(int col = 0; col < cols; col++){
    mean[col] = 0.000000001;
    for(int row = 0; row < rows; row++){
      mean[col] += targetMatrix[row][col];
    }
    mean[col] /= rows;
  }
  return mean;
}

double **vectorSubsMatrix(double *vector, double **targetMatrix, int rows, int cols){
  double **subs;
  subs = createAsymmetricMatrix(rows, cols);
  for(int col = 0; col < cols; col++){
    for(int row = 0; row < rows; row++){
      subs[row][col] = targetMatrix[row][col] - vector[col];
    }
  }
  return subs;
}

double **transposeMatrix(double **targetMatrix, int rows, int cols){
  double **transpose;
  transpose = createAsymmetricMatrix(cols, rows);
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      transpose[col][row] = targetMatrix[row][col];
    }
  }
  return transpose;
}

double **matrixProduct(double **matrix1, double **matrix2, int size){
  double **product;
  product = createMatrix(size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      product[row][col] = 0;
      for(int k = 0; k < size; k++){
	product[row][col] += matrix1[row][k] * matrix2[k][col];
      }
    }
  }
  return product;
}

double **asymmetricMatrixProduct(double **matrix1, int rows1, int cols1, double **matrix2, int rows2, int cols2){
  double **product;
  product = createAsymmetricMatrix(rows1, cols2);
  for(int row = 0; row < rows1; row++){
    for(int col = 0; col < cols2; col++){
      product[row][col] = 0;
      for(int k = 0; k < cols1; k++){
	product[row][col] += matrix1[row][k] * matrix2[k][col];
      }
    }
  }
  return product;
}

double **scalarMatrixSubs(double scalar, double **targetMatrix, int size){
  double **subs;
  subs = createMatrix(size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      subs[row][col] = targetMatrix[row][col] - scalar;
    }
  }
  return subs;
}

double **scalarMatrixProduct(double scalar, double **targetMatrix, int size){
  double **product;
  product = createMatrix(size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      product[row][col] = targetMatrix[row][col] * scalar;
    }
  }
  return product;
}

double **scalarAsymmetricMatrixProduct(double scalar, double **targetMatrix, int rows, int cols){
  double **product;
  product = createAsymmetricMatrix(rows, cols);
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      product[row][col] = targetMatrix[row][col] * scalar;
    }
  }
  return product;
}

double *unfoldMatrix(double **targetMatrix, int rows, int cols){
  double *unfolded;
  unfolded = createVector(rows*cols);
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      unfolded[col+(row*cols)] = targetMatrix[row][col];
    }
  }
  return unfolded;
}

double **foldVector(double *vector, int size){
  double **matrix;
  matrix = createMatrix(size);
  for(int i = 0; i < (size*size); i++){
    matrix[(int) (i/size)][i % size] = vector[i];
  }
  return matrix;
}

double **foldAsymmetricVector(double *vector, int rows, int cols){
  double **matrix;
  matrix = createAsymmetricMatrix(rows, cols);
  for(int i = 0; i < (rows*cols); i++){
    matrix[(int) (i/cols)][i % cols] = vector[i];
  }
  return matrix;
}

double **eigenValues(double **targetMatrix, int size){
  double **eigenVidentity;
  double *eigenV;
  eigenV = createVector(size);
  eigenVidentity = createMatrix(size);
  double *unfoldedMatrix;
  unfoldedMatrix = unfoldMatrix(targetMatrix, size, size);
  LAPACKE_dsyev(LAPACK_ROW_MAJOR,'N','U',size,unfoldedMatrix,size,eigenV);
  free(unfoldedMatrix);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      if(row == col){
	eigenVidentity[row][col] = eigenV[row];
      }
      else{
	eigenVidentity[row][col] = 0;
      }
    }
  }
  free(eigenV);
  return eigenVidentity;
}

double **eigenVectors(double **targetMatrix, int size){
  double *unfoldedMatrix;
  double *eigenV;
  eigenV = createVector(size);
  double **eigenMatrix;
  unfoldedMatrix = unfoldMatrix(targetMatrix, size, size);
  LAPACKE_dsyev(LAPACK_ROW_MAJOR,'V','U',size,unfoldedMatrix,size,eigenV);
  free(eigenV);
  eigenMatrix = foldVector(unfoldedMatrix, size);
  free(unfoldedMatrix);
  return eigenMatrix;
}

double **inverseDiagMatrix(double **targetMatrix, int size){
  double **inverse;
  inverse = createMatrix(size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      if(row == col){
	inverse[row][col] = 1/targetMatrix[row][col];
      }
      else{
	inverse[row][col] = 0;
      }
    }
  }
  return inverse;
}

double *inverseVector(double *vector, int size){
  double *inverse;
  inverse = createVector(size);
  for(int i = 0; i < size; i++){
    inverse[i] = 1.0/vector[i];
  }
  return inverse;
}

double **sqrtElementMatrix(double **targetMatrix, int size){
  double **rootMatrix;
  rootMatrix = createMatrix(size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      rootMatrix[row][col] = sqrt(targetMatrix[row][col]);
    }
  }
  return rootMatrix;
}

double **generateRandomMatrix(int limit, int size){
  double **randomMatrix;
  int randomNumber;
  randomMatrix = createMatrix(size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      randomNumber = (rand()+1) % (limit*1000);
      randomMatrix[row][col] = ((double)randomNumber) / 1000;
    }
  }
  return randomMatrix;
}

double **generateSines(int numSines, int samples, int minCycles){
  double **sources;
  double *freq;
  int maxFreq;
  int randomFreq;
  int sawToothState;
  int sawToothDots;
  double sawToothSteps;
  double sawTooth;
  maxFreq = samples/20;
  sources = createAsymmetricMatrix(samples, numSines);
  freq = createVector(numSines);
  for(int i = 0; i < numSines; i++){
    randomFreq = 0;
    while(randomFreq < minCycles){
      randomFreq = rand() % maxFreq;
    }
    freq[i] = randomFreq;
  }
  sawToothDots = (int) samples/freq[2];
  sawToothSteps = 1.0/sawToothDots;
  for(int rows = 0; rows < samples; rows++){
    for(int cols = 0; cols < numSines; cols++){
      switch(cols){
      case 0:
	sources[rows][cols] = sin(2*M_PI*freq[cols]*(rows/((double) samples)));
	break;
      case 1:
	if(sin(2*M_PI*freq[cols]*(rows/((double) samples))) > 0){
	  sources[rows][cols] = 1;
	}
	else{
	  sources[rows][cols] = -1;
	}
	break;
      case 2:
	sources[rows][cols] = sawTooth;
	sawTooth += sawToothSteps;
	if((rows % sawToothDots == 0)&&(rows != 0)){
	  sawTooth = 0;
	}
      }
      
    }
  }
  free(freq);
  return sources;
}

double **randomMixing(double **originalSources, int rows, int cols){
  double **mixMatrix;
  double **mixedMatrix;
  mixMatrix = generateRandomMatrix(5, cols);
  mixedMatrix = asymmetricMatrixProduct(originalSources, rows, cols, originalSources, cols, cols);
  freeMatrix(mixMatrix, cols);
  return mixedMatrix;
}

void printCSV(double ***matrix, int numMatrix, int rows, int cols){
  printf("time;sig1;sig2;sig3;mixed1;mixed2;mixed3;whi1;whi2;whi3;est1;est2;est3\n");
  for(int row = 0; row < rows; row++){
    printf("%f;", (row/((double)rows)));
    for(int contMatrix = 0; contMatrix < numMatrix; contMatrix++){
      for(int col = 0; col < cols; col++){
	printf("%f", matrix[contMatrix][row][col]);
	if((contMatrix != (numMatrix-1)) || (col != (cols-1))){
	  printf(";");
	}
      }
    }
    printf("\n");
  }
}

double *cpyRowMatrix(double **targetMatrix, int row, int cols){
  double *vector;
  vector = createVector(cols);
  for(int col = 0; col < cols; col++){
    vector[col] = targetMatrix[row][col];
  }
  return vector;
}

double *signVector(double *vector, int size){
  double *signs;
  signs = createVector(size);
  for(int i = 0; i < size; i++){
    if(vector[i]>0){
      signs[i] = 1;
    }
    else{
      signs[i] = -1;
    }
  }

  return signs;
}

double **vectorMatrixProduct(double *vector, double **targetMatrix, int rows, int cols){
  double **product;
  product = createAsymmetricMatrix(rows, cols);
  for(int col = 0; col < cols; col++){
    for(int row = 0; row < rows; row++){
      product[row][col] = targetMatrix[row][col] * vector[col];
    }
  }
  return product;
}

double **whiten(double **originalMatrix, int rows, int cols){
  double ***svdDec;
  double **centeredMatrix;
  double **originalMatrixTranspose;
  double **whitened;
  double **changeSignedU;
  double **uTranspose;
  double **kTranspose;
  double **k;
  double **whitenedNotNormalized;
  double **whitenedTranspose;
  double *invSigma;
  double *mean;
  double *realSigma;
  double *signsU;
  mean = meanMatrix(originalMatrix, rows, cols); //mean = mean(originalMatrix);
  //printVector(mean, N);
  centeredMatrix = vectorSubsMatrix(mean, originalMatrix, rows, cols); //centeredMatrix = originalMatrix - mean;
  //printMatrix(centeredMatrix, rows, cols);
  originalMatrixTranspose = transposeMatrix(originalMatrix, rows, cols); //originalMatrixTranspose = originalMatrix'
  //printMatrix(originalMatrixTranspose, cols, rows);
  svdDec = svdDecomposition(originalMatrixTranspose, cols, rows);
  //printMatrix(svdDec[0], cols, cols);
  //printMatrix(svdDec[1], cols, cols);
  realSigma = cpyRowMatrix(svdDec[1], 0, cols);
  signsU = signVector(svdDec[0][0], cols);
  //printVector(signsU, cols);
  changeSignedU = vectorMatrixProduct(signsU,svdDec[0],cols,cols);
  //printMatrix(changeSignedU, cols, cols);
  invSigma = inverseVector(realSigma, cols);
  kTranspose = vectorMatrixProduct(invSigma,changeSignedU,cols,cols);
  k = transposeMatrix(kTranspose,cols,cols);
  //printMatrix(k, cols, cols);
  whitenedNotNormalized = asymmetricMatrixProduct(k, cols, cols, originalMatrixTranspose, cols, rows);
  whitenedTranspose = scalarAsymmetricMatrixProduct(sqrt(rows), whitenedNotNormalized, cols, rows);
  whitened = transposeMatrix(whitenedTranspose,cols,rows);
  
  freeAsymmetricMatrix(whitenedTranspose, cols);
  freeAsymmetricMatrix(whitenedNotNormalized, cols);
  freeMatrix(k, cols);
  freeMatrix(kTranspose, cols);
  free(invSigma);
  free(realSigma);
  free(signsU);
  freeMatrix(changeSignedU, cols);
  free(mean);
  freeAsymmetricMatrix(centeredMatrix, cols);
  freeAsymmetricMatrix(originalMatrixTranspose, cols);
  freeMatrix(svdDec[0], cols);
  freeMatrix(svdDec[1], cols);
  free(svdDec);
  return whitened;
}

double ***svdDecomposition(double **targetMatrix, int rows, int cols){
  double ***usMatrix;
  double *uVector;
  double *sigmaVector;
  usMatrix = (double ***) malloc(2 * sizeof(double **));
  int min = (rows > cols) ? cols : rows;
  double superb[min-1];
  uVector = createVector(rows*rows);
  sigmaVector = createVector(rows*rows);
  LAPACKE_dgesvd(LAPACK_ROW_MAJOR,'A','N',rows,cols,unfoldMatrix(targetMatrix, rows, cols),cols,sigmaVector,uVector,rows,NULL,cols,superb);
  usMatrix[0] = foldVector(uVector, rows);
  usMatrix[1] = foldVector(sigmaVector,rows);

  free(uVector);
  free(sigmaVector);
  return usMatrix;
}

double **unmixingMatrix(double **mixedSources, double **unmixMatrix, int rows, int cols){
  double **unmixedMatrix;
  unmixedMatrix = asymmetricMatrixProduct(unmixMatrix, cols, cols, mixedSources, rows, cols);
  return unmixedMatrix;
}

uint32_t decimal_float32_to_sign_magnitude_integer16(float number)
{
  uint32_t  converted_number;

  uint32_t* float_raw_bits = (uint32_t *) &number;
  bool      sign           = (*float_raw_bits) & (0x80000000);
  uint8_t   exponent       = ((*float_raw_bits) & (0x7F800000)) >> 23;
  uint32_t  mantissa       = (((*float_raw_bits) & (0x007FFFFF)) | (0x00800000)) >> 8;
  bool      approximate;

  uint8_t   shift_value    = 126 - exponent;

  if(exponent >= (126-RES))
    {
      converted_number = mantissa >> shift_value;
      converted_number = (mantissa & (0x00000001 << shift_value-1)) ? converted_number+1 : converted_number;
      if(sign){
	converted_number |= 0x00010000;
	printf("%x\n", converted_number);
      }
    }
  else
    {
      converted_number = 0;
    }

  //printf("El flotante en hexa es: %x, el exponente: %d, la mantissa %x, el número convertido: %x y el shift: %d\n", *float_raw_bits, exponent, mantissa, co\
nverted_number, shift_value);                                                                                                                                 

  return converted_number;
}

char* sign_magnitude_integer16_to_binary(uint32_t number)
{
  char integer_bits[16];
  char* p_integer_bits = integer_bits;
  number &= 0x0000FFFF;
  for(char i = 0; i < 16; i++)
    {
      integer_bits[i] = number % 2;
      number /= 2;
    }

  return p_integer_bits;
}

float sign_magnitude_integer16_to_float(uint32_t number)
{
  float* converted_number;
  uint32_t converted_number_raw = 0;
  char* number_raw_bits;
  char scientific_shift = 0;

  number_raw_bits = sign_magnitude_integer16_to_binary(number);
  for(char i = 15; (i >= 0) && (number_raw_bits[i] == 0); i--)
    {
      scientific_shift ++;
    }

  converted_number_raw |= ((number & 0x00010000) << 15) | ((126-scientific_shift) << 23) | (number & (0x0000FFFF >> (1+scientific_shift))) << (23-(16-(scient\
ific_shift+1)));
  if(number & 0x00010000){
    printf("number was %x, new %x\n", number, converted_number_raw);
  }


  converted_number = (float *) &converted_number_raw;
  //printf("El flotante quedaría como: %x\n", converted_number_raw);                                                                                          

  return *converted_number;
}

void matrix_format(double **unmix_matrix, int cols)
{
  for(int i = 0; i < (cols*cols); i++)
    {
      unmix_matrix[(int) i/3][i%3] = (double) (sign_magnitude_integer16_to_float((decimal_float32_to_sign_magnitude_integer16((float) unmix_matrix[(int) i/3][i%3]))));
    }
}
