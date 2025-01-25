#include <data_conversion.h>


int main()
{
    float value = 0;
    float value2 = 0;
    uint32_t value_integer = 0;
    uint32_t value2_integer = 0;
    uint32_t resultado_mult_integer = 0;
    float resultado_mult = 0;

    printf("Ingrese el valor del primer numero a multiplicar\n");
    scanf("%f", &value);

    printf("Ingrese el valor del segundo numero a multiplicar\n");
    scanf("%f", &value2);
    printf("Producto en float hexa %08x\n", *((uint32_t *) &value));
    value_integer = decimal_float32_to_integer32(value, 6);
    printf("Value1 en integer %d\n", value_integer);
    printf("Value1 en integer %08x\n", value_integer);
    value2_integer = decimal_float32_to_integer32(value2, 6);
    printf("Value2 en integer %d\n", value2_integer);
    resultado_mult_integer = value_integer * value2_integer;
    printf("Producto en integer %u\n", resultado_mult_integer);
    printf("Producto en integer hexa %08x\n", resultado_mult_integer);
    resultado_mult = (float) resultado_mult_integer;//integer32_to_float(resultado_mult_integer, 0);
    printf("Producto en float %f\n", resultado_mult);
    printf("Producto en float hexa %08x\n", *((uint32_t *) &resultado_mult));
    resultado_mult *=  4096;//integer32_to_float(resultado_mult_integer, 0);
    printf("Producto en float %f\n", resultado_mult);
    printf("Producto en float hexa %08x\n", *((uint32_t *) &resultado_mult));    

}