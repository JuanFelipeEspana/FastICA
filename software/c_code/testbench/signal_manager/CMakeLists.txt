cmake_minimum_required(VERSION 3.10)

project(signal_manager)

add_library(signal_manager SHARED
        signal_manager.h
        signal_manager.c)

target_include_directories(signal_manager PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(signal_manager PUBLIC /home/juanfelipe/Documents/universidad/tesis/hardware/matrix_multiplier/hw/modelsim/testbench/array_utilities)

target_link_libraries(signal_manager
        array_utilities
)