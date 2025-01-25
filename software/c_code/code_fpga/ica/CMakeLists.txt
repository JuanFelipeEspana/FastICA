cmake_minimum_required(VERSION 3.5)

project(ica)

add_library(ica SHARED
        ica.h
        ica.c)

target_include_directories(ica PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(ica PUBLIC /home/ubuntu/Documents/thesis/code/matrix)

target_link_libraries(ica
        matrix
)