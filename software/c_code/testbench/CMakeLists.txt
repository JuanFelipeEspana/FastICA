cmake_minimum_required(VERSION 3.10)

project(testbench_generator)

add_subdirectory(array_utilities)
add_subdirectory(data_conversion)
add_subdirectory(signal_manager)
add_subdirectory(entity_manager)
add_subdirectory(matrix)

add_executable(testbench_generator testbench_generator.c)

target_link_libraries(testbench_generator
        array_utilities
        data_conversion
        signal_manager
        entity_manager
        matrix
)