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

# Create a .pc file for the specified target
#
#   PACKAGE_CONFIG_FILE(TARGET target
#                       VERSION version
#                       DESTINATION directory
#                       [CFLAGS flags]
#                       [LFLAGS flags])
#
# A pkg-config (.pc) file will be generated using the provided information.
function(PACKAGE_CONFIG_FILE)

    # Parse the arguments to the function
    set(options )
    set(oneValueArgs TARGET VERSION DESTINATION CFLAGS LFLAGS)
    set(multiValueArgs )
    cmake_parse_arguments(PCF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Ensure no extra arguments were passed
    if(PCF_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "PACKAGE_CONFIG_FILE(): unrecognized arguments \"${PCF_UNPARSED_ARGUMENTS}\"")
    endif()

    # Ensure the required arguments were set
    if(NOT PCF_TARGET OR NOT PCF_VERSION OR NOT PCF_DESTINATION)
        message(FATAL_ERROR "PACKAGE_CONFIG_FILE(): TARGET, VERSION, and DESTINATION are required arguments")
    endif()

    # Build the first part of the pkg-config file
    set(contents "Name: ${PCF_TARGET}
Version: ${PCF_VERSION}")

    # Add the compiler flags if included
    if(PCF_CFLAGS)
        set(contents "${contents}
Cflags: ${PCF_CFLAGS}")
    endif()

    # Add the linker flags if included
    if(PCF_LFLAGS)
        set(contents "${contents}
Libs: ${PCF_LFLAGS}")
    endif()

    # Write the file to disk and ensure it is installed to the correct location
    set(pcFilename "${CMAKE_CURRENT_BINARY_DIR}/${PCF_TARGET}.pc")
    file(GENERATE OUTPUT ${pcFilename} CONTENT ${contents})
    install(FILES ${pcFilename} DESTINATION ${PCF_DESTINATION})
endfunction()
