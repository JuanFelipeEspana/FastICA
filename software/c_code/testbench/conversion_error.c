#include <data_conversion.h>

int main()
{
  char* error_csv = "error.csv";

  FILE* fp = fopen(error_csv, "w");

  float float_itr = 0.0000001;
  float float_approx = 0;
  float error = 0;
  uint32_t int16_max_value = 65536;
  uint32_t int_real = 0;
  uint32_t int_approx = 0;
  fprintf(fp, "float_value, approximation, error\n");
  while(float_itr < 1)
    {
      float_approx = (sign_magnitude_integer16_to_float(decimal_float32_to_sign_magnitude_integer16(float_itr)));
      int_real = (int16_max_value * float_itr);
      int_approx = (int16_max_value * float_approx);
      error = ((((float)int_real)-((float)int_approx))/((float)int_real)) * 100;
      if(error < 0)
	    error *= -1;
      fprintf(fp, "%d,%d,%d,%f\n", int_real, int_approx, int_real-int_approx, error);
      float_itr += 0.0000001;
    }

  fclose(fp);
}