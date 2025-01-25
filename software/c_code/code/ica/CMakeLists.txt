cmake_minimum_required(VERSION 3.10)

project(ica)

add_library(ica SHARED
        ica.h
        ica.c)

target_include_directories(ica PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(ica PUBLIC /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/matrix)

target_link_libraries(ica
        matrix
)