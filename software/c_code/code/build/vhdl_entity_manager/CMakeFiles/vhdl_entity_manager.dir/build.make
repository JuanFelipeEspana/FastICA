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
include vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/compiler_depend.make

# Include the progress variables for this target.
include vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/progress.make

# Include the compile flags for this target's objects.
include vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/flags.make

vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o: vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/flags.make
vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o: ../vhdl_entity_manager/vhdl_entity_manager.c
vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o: vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/vhdl_entity_manager && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o -MF CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o.d -o CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o -c /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/vhdl_entity_manager/vhdl_entity_manager.c

vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.i"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/vhdl_entity_manager && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/vhdl_entity_manager/vhdl_entity_manager.c > CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.i

vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.s"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/vhdl_entity_manager && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/vhdl_entity_manager/vhdl_entity_manager.c -o CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.s

# Object files for target vhdl_entity_manager
vhdl_entity_manager_OBJECTS = \
"CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o"

# External object files for target vhdl_entity_manager
vhdl_entity_manager_EXTERNAL_OBJECTS =

vhdl_entity_manager/libvhdl_entity_manager.so: vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/vhdl_entity_manager.c.o
vhdl_entity_manager/libvhdl_entity_manager.so: vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/build.make
vhdl_entity_manager/libvhdl_entity_manager.so: vhdl_signal_manager/libvhdl_signal_manager.so
vhdl_entity_manager/libvhdl_entity_manager.so: array_utilities/libarray_utilities.so
vhdl_entity_manager/libvhdl_entity_manager.so: vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C shared library libvhdl_entity_manager.so"
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/vhdl_entity_manager && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/vhdl_entity_manager.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/build: vhdl_entity_manager/libvhdl_entity_manager.so
.PHONY : vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/build

vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/clean:
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/vhdl_entity_manager && $(CMAKE_COMMAND) -P CMakeFiles/vhdl_entity_manager.dir/cmake_clean.cmake
.PHONY : vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/clean

vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/depend:
	cd /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/juanfelipe/Documents/universidad/tesis/software/c_code/code /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/vhdl_entity_manager /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/vhdl_entity_manager /home/juanfelipe/Documents/universidad/tesis/software/c_code/code/build/vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : vhdl_entity_manager/CMakeFiles/vhdl_entity_manager.dir/depend

