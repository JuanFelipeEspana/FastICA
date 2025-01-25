cmake_minimum_required(VERSION 3.5)

add_library(data_conversion SHARED
        data_conversion.h
        data_conversion.c)

target_include_directories(data_conversion PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})