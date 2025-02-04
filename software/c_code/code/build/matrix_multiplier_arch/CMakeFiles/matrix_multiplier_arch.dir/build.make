# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/juanfelipe/Documents/universidad/tesis/software/c_code/code

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build

# Include any dependencies generated for this target.
include matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/compiler_depend.make

# Include the progress variables for this target.
include matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/progress.make

# Include the compile flags for this target's objects.
include matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/flags.make

matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o: matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/flags.make
matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o: ../matrix_multiplier_arch/matrix_multiplier_arch.c
matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o: matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/matrix_multiplier_arch && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o -MF CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o.d -o CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o -c /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/matrix_multiplier_arch/matrix_multiplier_arch.c

matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.i"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/matrix_multiplier_arch && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/matrix_multiplier_arch/matrix_multiplier_arch.c > CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.i

matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.s"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/matrix_multiplier_arch && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/matrix_multiplier_arch/matrix_multiplier_arch.c -o CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.s

# Object files for target matrix_multiplier_arch
matrix_multiplier_arch_OBJECTS = \
"CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o"

# External object files for target matrix_multiplier_arch
matrix_multiplier_arch_EXTERNAL_OBJECTS =

matrix_multiplier_arch/libmatrix_multiplier_arch.so: matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/matrix_multiplier_arch.c.o
matrix_multiplier_arch/libmatrix_multiplier_arch.so: matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/build.make
matrix_multiplier_arch/libmatrix_multiplier_arch.so: matrix/libmatrix.so
matrix_multiplier_arch/libmatrix_multiplier_arch.so: array_utilities/libarray_utilities.so
matrix_multiplier_arch/libmatrix_multiplier_arch.so: data_conversion/libdata_conversion.so
matrix_multiplier_arch/libmatrix_multiplier_arch.so: matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C shared library libmatrix_multiplier_arch.so"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/matrix_multiplier_arch && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/matrix_multiplier_arch.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/build: matrix_multiplier_arch/libmatrix_multiplier_arch.so
.PHONY : matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/build

matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/clean:
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/matrix_multiplier_arch && $(CMAKE_COMMAND) -P CMakeFiles/matrix_multiplier_arch.dir/cmake_clean.cmake
.PHONY : matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/clean

matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/depend:
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/juanfelipe/Documents/universidad/tesis/software/c_code/code /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/matrix_multiplier_arch /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/matrix_multiplier_arch /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : matrix_multiplier_arch/CMakeFiles/matrix_multiplier_arch.dir/depend

