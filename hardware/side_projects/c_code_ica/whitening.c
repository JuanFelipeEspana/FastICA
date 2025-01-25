#include <stdio.h>
#include <stdlib.h>
#include <lapacke.h>
#include <math.h>
#include <time.h>

#define N 3
#define N_SAMPLES 1000

double **createMatrix(int size);
double **createAsymmetricMatrix(int rows, int cols);
void freeMatrix(double **targetMatrix, int size);
void freeAsymmetricMatrix(double **targetMatrix, int rows);
double *createVector(int size);
void printMatrix(double **targetMatrix, int size);
void printVector(double *targetVector, int size);
double *meanMatrix(double **targetMatrix, int size);
double **vectorSubsMatrix(double *vector, double **targetMatrix, int size);
double **transposeMatrix(double **targetMatrix, int size);
double **matrixProduct(double **matrix1, double **matrix2, int size);
double **scalarMatrixSubs(double scalar, double **targetMatrix, int size);
double **scalarMatrixProduct(double scalar, double **targetMatrix, int size);
double *unfoldMatrix(double **targetMatrix, int size);
double **foldVector(double *vector, int size);
double **eigenValues(double **targetMatrix, int size);
double **eigenVectors(double **targetMatrix, int size);
double **inverseDiagMatrix(double **targetMatrix, int size);
double **sqrtElementMatrix(double **targetMatrix, int size);
double **generateRandomMatrix(int limit, int size);
double **generateSines(int numSines, int samples, int minCycles);
double **randomMixing(double **originalSources, int rows, int cols);
void printCSV(double ***matrix, int numMatrix, int rows, int cols);
double **whiten(double **originalMatrix, int size);
double **whitenAsymmetric(double **targetMatrix, int rows, int cols);

int main(){
  double **whitened;
  double **realData;
  double **mixedData;
  int realSamples = N*((int) N_SAMPLES/N);
  srand(time(NULL));

  realData = generateSines(N, N_SAMPLES, 10);
  mixedData = randomMixing(realData, N_SAMPLES, N);
  whitened = whitenAsymmetric(mixedData, realSamples, N);
  
  double **printableMatrix[] = {realData,mixedData,whitened};
  printCSV(printableMatrix,3,realSamples,N);
  
  freeAsymmetricMatrix(realData, N_SAMPLES);
  freeAsymmetricMatrix(mixedData, realSamples);
  freeAsymmetricMatrix(whitened,realSamples);
  return 0;
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

void printMatrix(double **targetMatrix, int size){
  printf("\n");
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
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

double *meanMatrix(double **targetMatrix, int size){
  double *mean;
  mean = createVector(size);
  for(int col = 0; col < size; col++){
    mean[col] = 0;
    for(int row = 0; row < size; row++){
      mean[col] += targetMatrix[row][col];
    }
    mean[col] /= size;
  }
  return mean;
}

double **vectorSubsMatrix(double *vector, double **targetMatrix, int size){
  double **subs;
  subs = createMatrix(size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      subs[row][col] = targetMatrix[row][col] - vector[col];
    }
  }
  return subs;
}

double **transposeMatrix(double **targetMatrix, int size){
  double **transpose;
  transpose = createMatrix(size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
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

double *unfoldMatrix(double **targetMatrix, int size){
  double *unfolded;
  unfolded = createVector(size*size);
  for(int row = 0; row < size; row++){
    for(int col = 0; col < size; col++){
      unfolded[col+(row*size)] = targetMatrix[row][col];
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

double **eigenValues(double **targetMatrix, int size){
  double **eigenVidentity;
  double *eigenV;
  eigenV = createVector(size);
  eigenVidentity = createMatrix(size);
  double *unfoldedMatrix;
  unfoldedMatrix = unfoldMatrix(targetMatrix, size);
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
  unfoldedMatrix = unfoldMatrix(targetMatrix, size);
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
  printf("FRECUENCIAS DE LOS SENOS: \n");
  printVector(freq, numSines);
  for(int rows = 0; rows < samples; rows++){
    for(int cols = 0; cols < numSines; cols++){
      sources[rows][cols] = sin(2*M_PI*freq[cols]*(rows/((double) samples)));
      }
  }
  free(freq);
  return sources;
}

double **randomMixing(double **originalSources, int rows, int cols){
  double **mixMatrix;
  double **slicedOriginalMatrix;
  double **slicedMixedMatrix;
  double **mixedMatrix;
  mixMatrix = generateRandomMatrix(5, cols);
  printf("\nMATRIZ DE COMBINACIÓN: \n");
  printMatrix(mixMatrix, cols);
  slicedOriginalMatrix = createMatrix(cols);
  mixedMatrix = createAsymmetricMatrix(cols*((int)(rows/cols)),cols);
  for(int block = 0; block < ((int)(rows/cols)); block++){
    //TOMAMOS UNA PORCION DE LOS DATOS ORIGINALES
    for(int row = (block*cols); row < ((block+1)*cols); row++){
      for(int col = 0; col < cols; col++){
	slicedOriginalMatrix[row-(block*cols)][col] = originalSources[row][col];
      }
    }
    slicedMixedMatrix = matrixProduct(mixMatrix, slicedOriginalMatrix, cols);
    for(int row = (block*cols); row < ((block+1)*cols); row++){
      for(int col = 0; col < cols; col++){
	mixedMatrix[row][col] = slicedMixedMatrix[row-(block*cols)][col];
      }
    }
    freeMatrix(slicedMixedMatrix, cols);
  }
  freeMatrix(mixMatrix, cols);
  freeMatrix(slicedOriginalMatrix, cols);
  return mixedMatrix;
}

void printCSV(double ***matrix, int numMatrix, int rows, int cols){
  printf("time;sin1;sin2;sin3;mixed1;mixed2;mixed3;whitened1;whitened2;whitened3\n");
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

double **whiten(double **originalMatrix, int size){
  double **centeredMatrix;
  double **originalMatrixTranspose;
  double **covarianceNotNormalized;
  double **covarianceNormalized;
  double **eigenval;
  double **eigenMatrix;
  double **decorrelated;
  double **sqEigenValues;
  double **invSqEigenValues;
  double **whitened;
  double *mean;
  mean = meanMatrix(originalMatrix, N); //mean = mean(originalMatrix);
  //printVector(mean, N);
  centeredMatrix = vectorSubsMatrix(mean, originalMatrix, N); //centeredMatrix = originalMatrix - mean;
  //printMatrix(centeredMatrix, N);
  originalMatrixTranspose = transposeMatrix(originalMatrix, N); //originalMatrixTranspose = originalMatrix'
  covarianceNotNormalized = matrixProduct(originalMatrixTranspose, originalMatrix, N); //covNotNorm = originalMat' * originalMat
  covarianceNormalized = scalarMatrixProduct((1.0/N), covarianceNotNormalized, N); //covNorm = covNotNorm/dim(originalMat[0])
  //printMatrix(covarianceNormalized, N);
  eigenval = eigenValues(covarianceNormalized, N); //eigenvalues(covarianceNormalized)
  //printMatrix(eigenval, N);
  eigenMatrix = eigenVectors(covarianceNormalized, N); //eigenvectors(covarianceNormalized)
  //printMatrix(eigenMatrix, N);
  decorrelated = matrixProduct(originalMatrix,eigenMatrix,N); //decorrelated = originalMat * eigenMatrix
  //printMatrix(decorrelated, N);
  sqEigenValues = sqrtElementMatrix(eigenval, N);
  invSqEigenValues = inverseDiagMatrix(sqEigenValues, N);
  whitened = matrixProduct(decorrelated,invSqEigenValues,N);
  
  free(mean);
  freeMatrix(centeredMatrix, N);
  freeMatrix(originalMatrixTranspose, N);
  freeMatrix(covarianceNotNormalized, N);
  freeMatrix(covarianceNormalized, N);
  freeMatrix(eigenval, N);
  freeMatrix(eigenMatrix, N);
  freeMatrix(decorrelated, N);
  freeMatrix(sqEigenValues, N);
  freeMatrix(invSqEigenValues, N);
  return whitened;
}

double **whitenAsymmetric(double **targetMatrix, int rows, int cols){
  double **slicedOriginalMatrix;
  double **slicedWhitenedMatrix;
  double **whitenedMatrix;
  slicedOriginalMatrix = createMatrix(cols);
  whitenedMatrix = createAsymmetricMatrix(cols*((int)(rows/cols)),cols);
  for(int block = 0; block < ((int)(rows/cols)); block++){
    //TOMAMOS UNA PORCION DE LOS DATOS ORIGINALES
    for(int row = (block*cols); row < ((block+1)*cols); row++){
      for(int col = 0; col < cols; col++){
	slicedOriginalMatrix[row-(block*cols)][col] = targetMatrix[row][col];
      }
    }
    slicedWhitenedMatrix = whiten(slicedOriginalMatrix, cols);
    for(int row = (block*cols); row < ((block+1)*cols); row++){
      for(int col = 0; col < cols; col++){
	whitenedMatrix[row][col] = slicedWhitenedMatrix[row-(block*cols)][col];
      }
    }
    freeMatrix(slicedWhitenedMatrix, cols);
  }
  freeMatrix(slicedOriginalMatrix, cols);
  return whitenedMatrix;
}
  
  
