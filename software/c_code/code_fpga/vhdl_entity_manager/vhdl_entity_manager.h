#ifndef ENTITY_MANAGER

#define ENTITY_MANAGER

#include <array_utilities.h>
#include <vhdl_signal_manager.h>

#define ENTITY_NAME_MAX_CHARACTERS 30
#define ENTITY_ARCHITECTURE_MAX_CHARACTERS 20
#define ENTITY_MAX_SIGNALS         30

typedef struct entity
{
    char                 name[ENTITY_NAME_MAX_CHARACTERS];
    char architecture[ENTITY_ARCHITECTURE_MAX_CHARACTERS];
    signal                    signals[ENTITY_MAX_SIGNALS];
    uint8_t                                 signals_total;
} entity;

void entity_create(entity* entity, char name[], char architecture[], signal* entity_signals, uint8_t signals_total);
void entity_add_signal(entity* entity, signal* signal);
void entity_header_print(entity* entity);
void entity_footer_print(entity* entity);

#endif