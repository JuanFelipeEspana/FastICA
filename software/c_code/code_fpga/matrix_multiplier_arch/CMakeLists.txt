cmake_minimum_required(VERSION 3.5)

project(matrix_multiplier_arch)

add_library(matrix_multiplier_arch SHARED
        matrix_multiplier_arch.h
        matrix_multiplier_arch.c)

target_include_directories(matrix_multiplier_arch PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(matrix_multiplier_arch PUBLIC /home/ubuntu/Documents/thesis/code/matrix/)

target_link_libraries(matrix_multiplier_arch
        matrix
)