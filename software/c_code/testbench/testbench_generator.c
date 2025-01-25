#include <array_utilities.h>
#include <data_conversion.h>
#include <signal_manager.h>
#include <entity_manager.h>
#include <matrix.h>
#include <float.h>

#define MAX_DIV 1000

void dut_print();
void avalon_write(signal* address, uint32_t addr, signal*writedata, uint32_t data, signal*write_en, uint16_t time, uint16_t clk, uint8_t absolute);
void avalon_read(signal* address, uint32_t addr, uint16_t time, uint8_t absolute);

int main() {
	srand(time(NULL));

	//DIMENSIONS
	uint8_t                matrix_a_rows = 3;
	uint8_t                matrix_b_cols = 3;
	uint8_t            matrix_dim_common = 3;

	//MATRIX A
	float_matrix  matrix_a_float_precision;
	float_matrix  matrix_a_int32_precision;
	int32_matrix            matrix_a_int32;

	//MATRIX B
	float_matrix  matrix_b_float_precision;
	float_matrix  matrix_b_int32_precision;
	int32_matrix            matrix_b_int32;
 
	//MATRIX RESULTS
	float_matrix        result_float_precision;
	float_matrix  result_float_int16_precision;
	int32_matrix                  result_int32;
	float_matrix            result_int32_float;

	//GET MATRIX A AND B DIMENSIONS
	/*
	printf("Number of rows matrix A: \n");
	scanf("%hhu", &matrix_a_rows);
	printf("Common dimension between matrix A and B: \n");
	scanf("%hhu", &matrix_dim_common);
	printf("Number of columns matrix B: \n");
	scanf("%hhu", &matrix_b_cols);
    */

	//CREATE MATRIX A
	float_matrix_create(&matrix_a_float_precision, matrix_a_rows, matrix_dim_common);
	float_matrix_create(&matrix_a_int32_precision, matrix_a_rows, matrix_dim_common);
	int32_matrix_create(&matrix_a_int32, matrix_a_rows, matrix_dim_common);

	//CREATE MATRIX B
	float_matrix_create(&matrix_b_float_precision, matrix_dim_common, matrix_b_cols);
	float_matrix_create(&matrix_b_int32_precision, matrix_dim_common, matrix_b_cols);
	int32_matrix_create(&matrix_b_int32, matrix_a_rows, matrix_dim_common);

	//CREATE RESULT MATRIX
	float_matrix_create(&result_float_precision, matrix_a_rows, matrix_b_cols);
	float_matrix_create(&result_float_int16_precision, matrix_a_rows, matrix_b_cols);
	int32_matrix_create(&result_int32, matrix_a_rows, matrix_b_cols);
	float_matrix_create(&result_int32_float, matrix_a_rows, matrix_b_cols);

    int8_t max_exponent_a = 0;
	//FILL MATRIX A
	//float_matrix_fill_random(&matrix_a_float_precision, mypow(2, 16)-1, 0);
	
	float xd[] = {25022.000000,-8239.000000,-64779.000000,35750.000000,12503.000000,-17868.000000,39957.000000,-59139.000000,-55686.000000};
	for(uint32_t i = 0; i < ((matrix_a_float_precision.rows)*(matrix_a_float_precision.cols)); i++)
	{
		*(matrix_a_float_precision.address + i) = xd[i];
	}
	
	
	float_matrix_to_int32_matrix(&matrix_a_float_precision, &matrix_a_int32, max_exponent_a);
	int32_matrix_to_float_matrix(&matrix_a_int32, &matrix_a_int32_precision, max_exponent_a);

	int8_t max_exponent_b = -8;
	//FILL MATRIX B
	//float_matrix_fill_random(&matrix_b_float_precision, mypow(2, 16)-1, 1);
	
	float xd2[] = {116.632812,131.753906,71.675781,39.605469,-37.082031,65.628906,-116.460938,93.062500,-171.195312};
	for(uint32_t i = 0; i < ((matrix_b_float_precision.rows)*(matrix_b_float_precision.cols)); i++)
	{
		*(matrix_b_float_precision.address + i) = xd2[i];
	}
	
	float_matrix_to_int32_matrix(&matrix_b_float_precision, &matrix_b_int32, max_exponent_b);
	int32_matrix_to_float_matrix(&matrix_b_int32, &matrix_b_int32_precision, max_exponent_b);

    int8_t total_shift = max_exponent_a + max_exponent_b;
	//MULTIPLY MATRICES
	float_matrix_multiply(&matrix_a_float_precision, &matrix_b_float_precision, &result_float_precision);
	int32_matrix_multiply(&matrix_a_int32, &matrix_b_int32, &result_int32);
	int32_matrix_full_to_float_matrix(&result_int32, &result_int32_float, total_shift);
	float_matrix_multiply(&matrix_a_int32_precision, &matrix_b_int32_precision, &result_float_int16_precision);

	//CREATE SIGNALS	
	signal avalon_signals[7];
	signal_create(&avalon_signals[0],        "clk_tb", "std_logic", 1, 0, 1);
	signal_create(&avalon_signals[1],        "rst_tb", "std_logic", 1, 0, 1);
	signal_create(&avalon_signals[2],    "address_tb", "std_logic_vector", 18, 0, 0);
	signal_create(&avalon_signals[3], "chipselect_tb", "std_logic", 1, 0, 1);
	signal_create(&avalon_signals[4],   "write_en_tb", "std_logic", 1, 0, 0);
	signal_create(&avalon_signals[5],  "writedata_tb", "std_logic_vector", 32, 0, 0);
	signal_create(&avalon_signals[6],   "readdata_tb", "std_logic_vector", 32, 0, 0);

	//DEFINE STATEMENTS
	uint16_t rst_offset = 100;
	uint16_t clk_period = 10;
	uint64_t matrix_size = 0;
	uint16_t signal_hold_time = clk_period * 5;
	
	signal_add_value(&avalon_signals[1], 0, rst_offset, 1);
	avalon_write(&avalon_signals[2], 0x00000, &avalon_signals[5], matrix_a_rows, &avalon_signals[4], rst_offset, clk_period, 1);
	avalon_write(&avalon_signals[2], 0x00001, &avalon_signals[5], matrix_b_cols, &avalon_signals[4], signal_hold_time, clk_period, 0);
	avalon_write(&avalon_signals[2], 0x00002, &avalon_signals[5], matrix_dim_common, &avalon_signals[4], signal_hold_time, clk_period, 0);
	avalon_write(&avalon_signals[2], 0x00003, &avalon_signals[5], (matrix_a_rows*matrix_b_cols), &avalon_signals[4], signal_hold_time, clk_period, 0);
	avalon_write(&avalon_signals[2], 0x00004, &avalon_signals[5], total_shift, &avalon_signals[4], signal_hold_time, clk_period, 0);
	
	uint32_t* matrix_address;

	for(uint8_t i = 0; i < 2; i++)
	{
		if(i == 0)
		{
			matrix_size = matrix_a_rows * matrix_dim_common;
			matrix_address = (uint32_t* ) matrix_a_float_precision.address;
			avalon_write(&avalon_signals[2], 0x00005, &avalon_signals[5], max_exponent_a, &avalon_signals[4], signal_hold_time, clk_period, 0);
		}
		else
		{
			matrix_size = matrix_dim_common * matrix_b_cols;
			matrix_address = (uint32_t* ) matrix_b_float_precision.address;
			avalon_write(&avalon_signals[2], 0x00005, &avalon_signals[5], max_exponent_b, &avalon_signals[4], signal_hold_time, clk_period, 0);
		}
		avalon_write(&avalon_signals[2], 0x00006, &avalon_signals[5], matrix_size, &avalon_signals[4], signal_hold_time, clk_period, 0);
		for(uint64_t j = 0; j < matrix_size; j++){
			avalon_write(&avalon_signals[2], (1 << (avalon_signals[2].bits_size - 2)) + j, &avalon_signals[5], *(matrix_address + j), &avalon_signals[4], signal_hold_time, clk_period, 0);
		}
	}

	for(uint64_t i = 0; i < (matrix_a_rows*matrix_b_cols); i++)
	{
		if(i == 0)
		{
			avalon_read(&avalon_signals[2], (3 << (avalon_signals[2].bits_size - 2)) + i, (clk_period*(matrix_b_cols+1)), 0);
		}
		else
		{
			avalon_read(&avalon_signals[2], (3 << (avalon_signals[2].bits_size - 2)) + i, clk_period, 0);
		}
	}
	//printf("write_en	 tiene %d statements\n", avalon_signals[4].current_statement);
	//ENTITY matrix_multiplier_avalon_tb
	entity matrix_multiplier_avalon_tb;
	entity_create(&matrix_multiplier_avalon_tb, "matrix_multiplier_avalon_tb", "testbench", &avalon_signals[0], 7);
	entity_header_print(&matrix_multiplier_avalon_tb);
	printf("clk_tb <= not clk_tb after %u ns;\n", (uint8_t) (clk_period/2));
	for(uint8_t i = 0; i < (matrix_multiplier_avalon_tb.signals_total); i++)
	{
		signal_print_testbench(&(matrix_multiplier_avalon_tb.signals[i]));
	}
	dut_print();
	entity_footer_print(&matrix_multiplier_avalon_tb);

	printf("--MATRIZ A CON PRECISIÓN DE FLOTANTE\n");
	float_matrix_print(&matrix_a_float_precision);
	/*
	printf("--MATRIZ A DECIMAL CON PRECISIÓN DE ENTERO DE 16b\n");
	float_matrix_print(&matrix_a_int32_precision);
	printf("--MATRIZ A EN ENTERO\n");
	int32_matrix_print(&matrix_a_int32, 1);
	*/
	printf("--MATRIZ B CON PRECISION DE FLOTANTE\n");
	float_matrix_print(&matrix_b_float_precision);
	/*
	printf("--MATRIZ B CON PRECISIÓN DE ENTERO DE 16b\n");
	float_matrix_print(&matrix_b_int32_precision);
	printf("--MATRIZ B EN ENTERO\n");
	int32_matrix_print(&matrix_b_int32, 1);
	*/

	printf("--MATRIZ DE RESULTADOS CON DECIMALES FLOTANTES\n");
	float_matrix_print(&result_float_precision);
	printf("--MATRIZ DE RESULTADOS CON DECIMALES ENTEROS\n");
	float_matrix_print(&result_float_int16_precision);
	printf("--MATRIZ DE RESULTADOS DE LA ARQUITECTURA EN ENTEROS\n");
	int32_matrix_print(&result_int32, 0);
	printf("--MATRIZ DE RESULTADOS DE LA ARQUITECTURA\n");
	float_matrix_print(&result_int32_float);

	return 0;
}

void avalon_write(signal* address, uint32_t addr, signal*writedata, uint32_t data, signal*write_en, uint16_t time, uint16_t clk, uint8_t absolute)
{
	uint32_t real_number_statement = (address->current_statement) ? 1 : 0;
	uint32_t delay = time-(real_number_statement*clk);
	signal_add_value(address, addr, time, absolute);
	signal_add_value(writedata, data, time, absolute);
	signal_add_value(write_en, 1, delay, absolute);
	signal_add_value(write_en, 0, clk, 0);
}

void avalon_read(signal* address, uint32_t addr, uint16_t time, uint8_t absolute)
{
	signal_add_value(address, addr, time, absolute);
}

void dut_print()
{
	printf(
		"  dut : entity work.matrix_multiplier_avalon\n"
		"    port map(\n"
		"      wr_clk      =>      clk_tb,\n"
		"      rd_clk      =>      clk_tb,\n"
		"      rst         =>      rst_tb,\n"
		"      address     =>  address_tb,\n"
		"      chipselect  =>chipselect_tb,\n"
		"      write_en    => write_en_tb,\n"
		"      writedata   =>writedata_tb,\n"
		"      readdata    => readdata_tb\n"
		"    );\n\n"
	);
}
