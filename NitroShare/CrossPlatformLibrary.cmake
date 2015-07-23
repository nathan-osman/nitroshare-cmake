# The MIT License (MIT)
#
# Copyright (c) 2015 Nathan Osman
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

include(CMakeParseArguments)
include(NitroShare/CMakeExportFile)
include(NitroShare/PackageConfigFile)
include(NitroShare/SplitVersion)
include(NitroShare/WindowsResourceFile)

# Adds standard options for installation
#
#   CPL_OPTIONS()
#
# The macro adds the options (BIN|LIB|INCLUDE)_INSTALL_DIR. The macro checks
# for "doc", "examples", and "tests" directories and if they exist, the
# appropriate options and subdirectories are added.
macro(CPL_OPTIONS)

    # Add options to control installation directories
    set(BIN_INSTALL_DIR bin CACHE STRING "Runtime installation directory")
    set(LIB_INSTALL_DIR lib CACHE STRING "Library installation directory")
    set(INCLUDE_INSTALL_DIR include CACHE STRING "Header installation directory")

    # Check for the "doc" directory
    if(EXISTS doc)
        option(BUILD_DOC "Build documentation" OFF)
        if(BUILD_DOC)
            add_subdirectory(doc)
        endif()
    endif()

    # Check for the "examples" directory
    if(EXISTS examples)
        option(BUILD_EXAMPLES "Build example applications" OFF)
        if(BUILD_EXAMPLES)
            add_subdirectory(examples)
        endif()
    endif()

    # Check for the "tests" directory
    if(EXISTS tests)
        option(BUILD_TESTS "Build unit tests" OFF)
        if(BUILD_TESTS)
            enable_testing()
            add_subdirectory(tests)
        endif()
    endif()
endmacro()

# Create a library from the provided source files
#
#   CPL_LIBRARY(NAME name
#               VERSION version
#               SRC src1 [src2 ...])
#
# A directory with the same name as the target is expected to exist in the
# current source directory containing the public header files.
function(CPL_LIBRARY)

    # Parse the arguments to the function
    set(options )
    set(oneValueArgs NAME VERSION)
    set(multiValueArgs SRC)
    cmake_parse_arguments(CPL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Ensure no extra arguments were passed
    if(CPL_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "CPL_LIBRARY(): unrecognized arguments \"${CPL_UNPARSED_ARGUMENTS}\"")
    endif()

    # Ensure the required arguments were set
    if(NOT CPL_NAME OR NOT CPL_VERSION)
        message(FATAL_ERROR "CPL_LIBRARY(): NAME and VERSION are required arguments")
    endif()

    # Find the header files
    file(GLOB HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/${CPL_NAME}/*")

    # Create the target
    add_library(${CPL_NAME} ${CPL_SRC} ${HEADERS})

    # Add the current source and binary directories to the list of include
    # directories during building and add the installation path when installing
    target_include_directories(${CPL_NAME} PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
        "$<INSTALL_INTERFACE:${INCLUDE_INSTALL_DIR}>"
    )

    # Split the version
    split_version(CPL ${CPL_VERSION})

    # Set the properties for the target
    set_target_properties(${CPL_NAME} PROPERTIES
        PUBLIC_HEADER "${HEADERS}"
        VERSION ${CPL_VERSION}
        SOVERSION ${CPL_MAJOR}
    )

    # Install the target's files to the appropriate directories
    install(TARGETS ${CPL_NAME} EXPORT ${CPL_NAME}-export
        RUNTIME DESTINATION "${BIN_INSTALL_DIR}"
        LIBRARY DESTINATION "${LIB_INSTALL_DIR}"
        ARCHIVE DESTINATION "${LIB_INSTALL_DIR}"
        PUBLIC_HEADER DESTINATION "${INCLUDE_INSTALL_DIR}/${CPL_NAME}"
    )

    # Create a CMake export file
    cmake_export_file(TARGET ${CPL_NAME}
        EXPORT ${CPL_NAME}-export
        VERSION ${CPL_VERSION}
        DESTINATION "${LIB_INSTALL_DIR}/cmake/${CPL_NAME}"
    )

    # Create a pkg-config file
    package_config_file(TARGET ${CPL_NAME}
        VERSION ${CPL_VERSION}
        DESTINATION "${LIB_INSTALL_DIR}/pkgconfig"
        CFLAGS "-I${CMAKE_INSTALL_PREFIX}/${INCLUDE_INSTALL_DIR}"
        LFLAGS "-L${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR} -l${CPL_NAME}"
    )

    # Generate a resource file on Windows
    if(WIN32)
        windows_resource_file(TARGET ${CPL_NAME}
            VERSION ${CPL_VERSION}
        )
    endif()
endfunction()
