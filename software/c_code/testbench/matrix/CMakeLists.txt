cmake_minimum_required(VERSION 3.10)

project(matrix)

add_library(matrix SHARED
        matrix.h
        matrix.c)

target_include_directories(matrix PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(matrix PUBLIC /home/juanfelipe/Documents/universidad/tesis/hardware/matrix_multiplier/hw/modelsim/testbench/array_utilities)
target_include_directories(matrix PUBLIC /home/juanfelipe/Documents/universidad/tesis/hardware/matrix_multiplier/hw/modelsim/testbench/data_conversion)

target_link_libraries(matrix
        array_utilities
        data_conversion
)