cmake_minimum_required(VERSION 3.5)

add_library(array_utilities SHARED
        array_utilities.h
        array_utilities.c)

target_include_directories(array_utilities PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})