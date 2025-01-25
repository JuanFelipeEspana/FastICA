cmake_minimum_required(VERSION 3.5)

project(vhdl_signal_manager)

add_library(vhdl_signal_manager SHARED
        vhdl_signal_manager.h
        vhdl_signal_manager.c)

target_include_directories(vhdl_signal_manager PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(vhdl_signal_manager PUBLIC /home/ubuntu/Documents/thesis/code/array_utilities)

target_link_libraries(vhdl_signal_manager
        array_utilities
)