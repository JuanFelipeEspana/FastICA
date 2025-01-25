cmake_minimum_required(VERSION 3.5)

project(ica_for_eeg)

add_subdirectory(array_utilities)
add_subdirectory(data_conversion)
add_subdirectory(vhdl_signal_manager)
add_subdirectory(vhdl_entity_manager)
add_subdirectory(matrix)
add_subdirectory(ica)
add_subdirectory(signal_generator)
add_subdirectory(matrix_multiplier_arch)

add_executable(ica_for_eeg ica_for_eeg.c)

target_link_libraries(ica_for_eeg
        array_utilities
        data_conversion
        vhdl_signal_manager
        vhdl_entity_manager
        matrix
        ica
        signal_generator
        matrix_multiplier_arch
)