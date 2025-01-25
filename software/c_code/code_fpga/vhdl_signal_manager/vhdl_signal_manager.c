#include <vhdl_signal_manager.h>

void signal_create(signal* p_new_signal, char signal_name[], char signal_type[], uint32_t signal_bits_size, uint8_t order, uint32_t signal_initial_value)
{
  array_fill_zeros((p_new_signal->name), SIGNAL_NAME_MAX_CHAR, 1);
  array_fill_zeros((p_new_signal->type), SIGNAL_TYPE_MAX_CHAR, 1);
  array_fill_zeros((p_new_signal->values), SIGNAL_MAX_STATEMENTS, 4);
  array_fill_zeros((p_new_signal->times), SIGNAL_MAX_STATEMENTS, 2);
  
  array_copy(signal_name, (p_new_signal->name), string_size(signal_name), 1, 0);
  array_copy(signal_type, (p_new_signal->type), string_size(signal_type), 1, 0);
  (p_new_signal->bits_size) = signal_bits_size;
  (p_new_signal->order) = order;
  (p_new_signal->max_value) = mypow(2, signal_bits_size)-1;
  (p_new_signal->initial_value) = signal_initial_value;
  (p_new_signal->current_statement) = 0;

  /*
  printf("El nombre de la señal es: %s\n", p_new_signal->name);
  printf("El tipo de la señal es: %s\n", p_new_signal->type);
  printf("Su longitud en bits es: %u\n", p_new_signal->bits_size);
  printf("Su máximo valor es: %u\n", p_new_signal->max_value);
  printf("El valor inicial es: %u\n", p_new_signal->initial_value);
  printf("El número de statements es: %u\n", p_new_signal->current_statement);
  */
}

void signal_add_value(signal* signal, uint32_t value, uint16_t time, uint8_t absolute_time)
{
  uint8_t statement = (signal->current_statement);
  if((signal->max_value) >= value)
    {
      (signal->values[statement]) = value;
    }
  else
    {
      printf("WARNING: value cannot be represented with actual bits, value was left as 0\n");
    }
  if(!absolute_time)
    {
      (signal->times[statement]) = (statement) ? (signal->times[statement-1]) + time : time;
    }
  else
    {
      (signal->times[statement]) = time;
    }

  (signal->current_statement)++;
}

void signal_print_testbench(signal* signal)
{  
  if((signal->current_statement) != 0)
    printf("%s <= ", (signal->name));
  for(uint8_t i = 0; i < (signal->current_statement); i++)
  {
    for(uint8_t j = 0; (j < (string_size(signal->name) + 4)) && i; j++)
    {
      printf(" ");
    }
    signal_print_value(signal, (signal->values[i]));
    printf(" after %u ns", (signal->times[i]));
    if(i != ((signal->current_statement)-1))
    {
      printf(",");
    }
    else
    {
      printf(";");
    }
    printf("\n");
  }
  printf("\n");
}

void signal_print_value(signal* signal, uint32_t value)
{
  char format[21];
  uint8_t add_bits = signal_get_hexa_format(signal, format);
  if(add_bits)
  {
    uint8_t signal_hexas = (uint8_t) (signal->bits_size)/4;
    uint8_t additional_bits = (signal->bits_size)%4;
    uint8_t hexas_bits = signal_hexas * 4;
    switch (additional_bits)
    {
    case 1:
      printf(format, ((value)&(mypow(2, hexas_bits))) >> (hexas_bits), (value)&(mypow(2, hexas_bits)-1));
      break;
    case 2:
      //printf("%08x,value %08x \n", (mypow(2, hexas_bits+1)), value);
      printf(format, ((value)&(mypow(2, hexas_bits+1))) >> (hexas_bits+1), ((value)&(mypow(2, hexas_bits))) >> (hexas_bits), (value)&(mypow(2, hexas_bits)-1));
      break;
    case 3:
      printf(format, ((value)&(mypow(2, hexas_bits+2))) >> (hexas_bits+2),  ((value)&(mypow(2, hexas_bits+1))) >> (hexas_bits+1), ((value)&(mypow(2, hexas_bits)))  >> (hexas_bits), (value)&(mypow(2, hexas_bits)-1));
      break;
    }
  }
  else
  {
    printf(format, value);
  }
}


uint8_t signal_get_hexa_format(signal* signal, char format[21])
{
  char additional_limiter;
  char additional_bits[9];
  uint8_t signal_hexas = (uint8_t) ((signal->bits_size)/4);
  uint8_t additional_bits_num = ((signal->bits_size) % 4);
  uint8_t add_bits = 0;
  if((signal->bits_size) == 1)
  {
    snprintf(format, 16, "\'%%0%ux\'", signal_hexas);
  }
  else
  {
    if(additional_bits_num == 0)
    {
      snprintf(format, 21, "x\"%%0%ux\"", signal_hexas);
      add_bits = 0;
    }
    else{
      add_bits = 1;
      if(additional_bits_num == 1)
      {
        snprintf(additional_bits, 9, "\'%%u\'");

      }
      else if(additional_bits_num > 1)
      { 
        switch (additional_bits_num)
        {
        case 2:
          snprintf(additional_bits, 9, "\"%%x%%x\"");
          break;
        case 3:
          snprintf(additional_bits, 9, "\"%%x%%x%%x\"");
          break;
        }
      }
      snprintf(format, 21, "%s & x\"%%0%ux\"",additional_bits, signal_hexas);
    }
  }

  return add_bits;
}
