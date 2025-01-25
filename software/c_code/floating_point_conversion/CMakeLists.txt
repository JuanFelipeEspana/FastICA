cmake_minimum_required(VERSION 3.10)

project(floating_point_conversion)

add_subdirectory(data_conversion)

add_executable(floating_point_conversion floating_point_conversion.c)

target_link_libraries(floating_point_conversion
        data_conversion
)