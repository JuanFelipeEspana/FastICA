cmake_minimum_required(VERSION 3.10)

project(vhdl_entity_manager)

add_library(vhdl_entity_manager SHARED
        vhdl_entity_manager.h
        vhdl_entity_manager.c)

target_include_directories(vhdl_entity_manager PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})

target_include_directories(vhdl_entity_manager PUBLIC /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/array_utilities)
target_include_directories(vhdl_entity_manager PUBLIC /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/vhdl_signal_manager)

target_link_libraries(vhdl_entity_manager
        array_utilities
        vhdl_signal_manager
)