cmake_minimum_required(VERSION 3.10)

project(signal_generator)

add_library(signal_generator SHARED
        signal_generator.h
        signal_generator.c)

target_include_directories(signal_generator PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(signal_generator PUBLIC /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/matrix)

target_link_libraries(signal_generator
        matrix
        m
)