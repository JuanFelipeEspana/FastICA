cmake_minimum_required(VERSION 3.10)

project(entity_manager)

add_library(entity_manager SHARED
        entity_manager.h
        entity_manager.c)

target_include_directories(entity_manager PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(entity_manager PUBLIC /home/juanfelipe/Documents/universidad/tesis/hardware/matrix_multiplier/hw/modelsim/testbench/array_utilities)
target_include_directories(entity_manager PUBLIC /home/juanfelipe/Documents/universidad/tesis/hardware/matrix_multiplier/hw/modelsim/testbench/signal_manager)

target_link_libraries(entity_manager
        array_utilities
        signal_manager
)