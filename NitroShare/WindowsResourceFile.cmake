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
include(NitroShare/SplitVersion)

# Create an .rc file with the specified version information
#
#   WINDOWS_RESOURCE_FILE(TARGET target
#                         VERSION version
#                         [DESCRIPTION desc]
#                         [AUTHOR author])
#
# A windows resource (.rc) file will be generated with the information
# provided.
function(WINDOWS_RESOURCE_FILE)

    # Parse the arguments to the function
    set(options )
    set(oneValueArgs TARGET VERSION DESCRIPTION AUTHOR)
    set(multiValueArgs )
    cmake_parse_arguments(WRF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Ensure no extra arguments were passed
    if(WRF_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "WINDOWS_RESOURCE_FILE(): unrecognized arguments \"${WRF_UNPARSED_ARGUMENTS}\"")
    endif()

    # Ensure the required arguments were set
    if(NOT WRF_TARGET OR NOT WRF_VERSION)
        message(FATAL_ERROR "WINDOWS_RESOURCE_FILE(): TARGET and VERSION are required arguments")
    endif()

    # Split the version into its components
    split_version(WRF ${WRF_VERSION})

    # Build the first part of the resource file
    set(contents "#include <windows.h>

VS_VERSION_INFO VERSIONINFO
    FILEVERSION    ${WRF_MAJOR},${WRF_MINOR},${WRF_PATCH},0
    PRODUCTVERSION ${WRF_MAJOR},${WRF_MINOR},${WRF_PATCH},0
{
    BLOCK \"StringFileInfo\"
    {
        BLOCK \"040904b0\"
        {
            VALUE \"OriginalFilename\", \"$<TARGET_FILE_NAME:${WRF_TARGET}>\\0\"
            VALUE \"InternalName\",     \"${WRF_TARGET}\\0\"
            VALUE \"ProductName\",      \"${WRF_TARGET}\\0\"
            VALUE \"FileVersion\",      \"${WRF_VERSION}\\0\"
            VALUE \"ProductVersion\",   \"${WRF_VERSION}\\0\"")

    # Add the values that depend on the description being set
    if(WRF_DESCRIPTION)
        set(contents "${contents}
            VALUE \"FileDescription\",  \"${WRF_DESCRIPTION}\\0\"")
    endif()

    # Add the values that depend on the author being set
    if(WRF_AUTHOR)
        set(contents "${contents}
            VALUE \"CompanyName\",      \"${WRF_AUTHOR}\\0\"
            VALUE \"LegalCopyright\",   \"Copyright (c) 2015 ${WRF_AUTHOR}\\0\"")
    endif()

    # Append the end of the file
    set(contents "${contents}
        }
    }
    BLOCK \"VarFileInfo\"
    {
        VALUE \"Translation\", 0x409, 1252
    }
}")

    # Write the file to disk
    set(rcFilename "${CMAKE_CURRENT_BINARY_DIR}/${WRF_TARGET}.rc")
    file(GENERATE OUTPUT ${rcFilename} CONTENT ${contents})
    set_source_files_properties(${rcFilename}
        PROPERTIES GENERATED TRUE)

    # Create an empty C file to work around CMake complaining that
    # CMAKE_RC_CREATE_STATIC_LIBRARY is not set
    set(cFilename "${CMAKE_CURRENT_BINARY_DIR}/${WRF_TARGET}-empty.c")
    file(GENERATE OUTPUT ${cFilename} CONTENT "")
    set_source_files_properties(${cFilename}
        PROPERTIES GENERATED TRUE)

    # Create a static library containing the resource file and have the target
    # link to the static library
    set(rcTarget ${WRF_TARGET}-resource)
    add_library(${rcTarget} STATIC ${cFilename} ${rcFilename})
    target_link_libraries(${WRF_TARGET} PRIVATE ${rcTarget})
endfunction()
