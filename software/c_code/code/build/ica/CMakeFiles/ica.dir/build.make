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
include ica/CMakeFiles/ica.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include ica/CMakeFiles/ica.dir/compiler_depend.make

# Include the progress variables for this target.
include ica/CMakeFiles/ica.dir/progress.make

# Include the compile flags for this target's objects.
include ica/CMakeFiles/ica.dir/flags.make

ica/CMakeFiles/ica.dir/ica.c.o: ica/CMakeFiles/ica.dir/flags.make
ica/CMakeFiles/ica.dir/ica.c.o: ../ica/ica.c
ica/CMakeFiles/ica.dir/ica.c.o: ica/CMakeFiles/ica.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object ica/CMakeFiles/ica.dir/ica.c.o"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/ica && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT ica/CMakeFiles/ica.dir/ica.c.o -MF CMakeFiles/ica.dir/ica.c.o.d -o CMakeFiles/ica.dir/ica.c.o -c /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/ica/ica.c

ica/CMakeFiles/ica.dir/ica.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/ica.dir/ica.c.i"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/ica && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/ica/ica.c > CMakeFiles/ica.dir/ica.c.i

ica/CMakeFiles/ica.dir/ica.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/ica.dir/ica.c.s"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/ica && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/ica/ica.c -o CMakeFiles/ica.dir/ica.c.s

# Object files for target ica
ica_OBJECTS = \
"CMakeFiles/ica.dir/ica.c.o"

# External object files for target ica
ica_EXTERNAL_OBJECTS =

ica/libica.so: ica/CMakeFiles/ica.dir/ica.c.o
ica/libica.so: ica/CMakeFiles/ica.dir/build.make
ica/libica.so: matrix/libmatrix.so
ica/libica.so: array_utilities/libarray_utilities.so
ica/libica.so: data_conversion/libdata_conversion.so
ica/libica.so: ica/CMakeFiles/ica.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C shared library libica.so"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/ica && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ica.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
ica/CMakeFiles/ica.dir/build: ica/libica.so
.PHONY : ica/CMakeFiles/ica.dir/build

ica/CMakeFiles/ica.dir/clean:
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/ica && $(CMAKE_COMMAND) -P CMakeFiles/ica.dir/cmake_clean.cmake
.PHONY : ica/CMakeFiles/ica.dir/clean

ica/CMakeFiles/ica.dir/depend:
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/juanfelipe/Documents/universidad/tesis/software/c_code/code /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/ica /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/ica /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/ica/CMakeFiles/ica.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : ica/CMakeFiles/ica.dir/depend

