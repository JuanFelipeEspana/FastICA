cmake_minimum_required(VERSION 3.5)

project(matrix)

add_library(matrix SHARED
        matrix.h
        matrix.c)

target_include_directories(matrix PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(matrix PUBLIC /home/ubuntu/Documents/thesis/code/array_utilities)
target_include_directories(matrix PUBLIC /home/ubuntu/Documents/thesis/code/data_conversion)

target_link_libraries(matrix
        array_utilities
        data_conversion
        lapack
        blas
        lapacke
)