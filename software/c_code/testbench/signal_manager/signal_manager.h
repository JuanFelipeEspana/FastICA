#ifndef SIGNAL_MANAGER

#define SIGNAL_MANAGER

#include <array_utilities.h>

#define SIGNAL_NAME_MAX_CHAR    20
#define SIGNAL_TYPE_MAX_CHAR    30
#define SIGNAL_MAX_STATEMENTS  5000

typedef struct signal
{
  char         name[SIGNAL_NAME_MAX_CHAR];
  char         type[SIGNAL_TYPE_MAX_CHAR];
  uint32_t                      bits_size;
  uint8_t                           order;
  uint32_t                      max_value;
  uint32_t                  initial_value;
  uint32_t  values[SIGNAL_MAX_STATEMENTS];
  uint16_t   times[SIGNAL_MAX_STATEMENTS];
  uint32_t              current_statement;
} signal;

void signal_create(signal* p_new_signal, char signal_name[], char signal_type[], uint32_t signal_bits_size, uint8_t order, uint32_t signal_initial_value);
void signal_add_value(signal* signal, uint32_t value, uint16_t time, uint8_t absolute_time);
void signal_print_testbench(signal* signal);
void signal_print_value(signal* signal, uint32_t value);
uint8_t signal_get_hexa_format(signal* signal, char format[21]);

#endif