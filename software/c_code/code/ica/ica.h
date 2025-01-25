#include <matrix.h>

void ica_whiten(float_matrix* matrix, float_matrix* matrix_whitened);
void ica_deflanatory_orthogonalization(float_matrix* wp, uint32_t iteration, float_matrix* w, float_matrix* result);
float ica_g_fun(float_matrix* z, float_matrix* wp, int function);
float ica_gprime_fun(float_matrix* z, float_matrix* wp, int function);
void ica_calculate_matrix_unmixing(float_matrix* ica_matrix_mixed, uint32_t ica_number_samples, uint16_t ica_independent_components, float_matrix* ica_matrix_unmixing, float tol, uint32_t max_iter, uint8_t function);






