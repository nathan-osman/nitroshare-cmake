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

# Adds standard options for installation
#
#   CPL_OPTIONS()
#
# The macro checks for "doc", "examples", and "tests" directories and if they
# exist, the appropriate options and subdirectories are added.
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
