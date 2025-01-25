#include <vhdl_entity_manager.h>

void entity_create(entity* entity, char name[], char architecture[], signal* entity_signals, uint8_t signals_total)
{
    array_fill_zeros((entity->name), ENTITY_NAME_MAX_CHARACTERS, 1);
    array_fill_zeros((entity->architecture), ENTITY_ARCHITECTURE_MAX_CHARACTERS, 1);
    array_fill_zeros((entity->signals), ENTITY_MAX_SIGNALS, sizeof(signal));

    array_copy(name, (entity->name), string_size(name), 1, 0);
    array_copy(architecture, (entity->architecture), string_size(architecture), 1, 0);
    array_copy(entity_signals, (entity->signals), signals_total, sizeof(signal), 0);
    (entity->signals_total) = signals_total;
}

void entity_add_signal(entity* entity, signal* signal)
{
    (entity->signals[(entity->signals_total)]) = *signal;
    (entity->signals_total) ++;
}

void entity_header_print(entity* entity)
{
    char limiter = ' ';
    printf("library ieee;\n\n");
    printf("use ieee.std_logic_1164.all;\n");
    printf("use ieee.numeric_std.all;\n\n");
    printf("entity %s is \n", (entity->name));
    printf("end entity %s;\n\n", (entity->name));
    printf("architecture %s of %s is\n", (entity->architecture), (entity->name));
    
    for(uint8_t current_signal = 0; current_signal < (entity->signals_total); current_signal++)
    {
        printf("signal %s       :       %s", (entity->signals[current_signal]).name, (entity->signals[current_signal]).type);
        if((entity->signals[current_signal]).bits_size != 1)
        {
            if((entity->signals[current_signal]).order == 0)
            {
                printf("(%u downto %u)", (entity->signals[current_signal]).bits_size - 1, 0);
            }
            else
            {
                printf("(%u to %u)", 0, (entity->signals[current_signal]).bits_size - 1);
            }
        }
        printf(" := ");
        signal_print_value(&(entity->signals[current_signal]), (entity->signals[current_signal]).initial_value);
        printf(";\n");
    }

    printf("begin\n\n");
}

void entity_footer_print(entity* entity)
{
    printf("end architecture %s;\n", (entity->architecture));
}