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

include(CMakePackageConfigHelpers)
include(CMakeParseArguments)

# Generate CMake files that can be used to import the target
#
#   CMAKE_EXPORT_FILE(TARGET target
#                     VERSION version
#                     DESTINATION directory)
#
# Both the ${target}Config.cmake and ${target}ConfigVersion.cmake files will be
# generated and installed to the specified directory.
function(CMAKE_EXPORT_FILE)

    # Parse the arguments to the function
    set(options )
    set(oneValueArgs TARGET VERSION DESTINATION)
    set(multiValueArgs )
    cmake_parse_arguments(CEF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Ensure no extra arguments were passed
    if(CEF_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "CMAKE_EXPORT_FILE(): unrecognized arguments \"${CEF_UNPARSED_ARGUMENTS}\"")
    endif()

    # Ensure the required arguments were set
    if(NOT CEF_TARGET OR NOT CEF_VERSION OR NOT CEF_DESTINATION)
        message(FATAL_ERROR "CMAKE_EXPORT_FILE(): TARGET, VERSION, and DESTINATION are required arguments")
    endif()

    # Create the export file
    export(TARGETS ${CEF_TARGET} FILE "${CMAKE_CURRENT_BINARY_DIR}/${CEF_TARGET}Config.cmake")

    # Create the export version file
    write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/${CEF_TARGET}ConfigVersion.cmake"
        VERSION ${CEF_VERSION}
        COMPATIBILITY SameMajorVersion)

    # Install both files to the specified directory
    install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/${CEF_TARGET}Config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/${CEF_TARGET}ConfigVersion.cmake"
        DESTINATION "${CEF_DESTINATION}"
    )
endfunction()
