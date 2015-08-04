## NitroShare CMake Macros & Functions

A collection of CMake macros and functions that simplify the creation of the cross-platform executables and libraries that comprise the NitroShare project.

### Requirements

CMake 2.8.12+ is required to use the macros and functions.

### Installation

The entire collection can be installed by running the following commands:

    mkdir build
    cd build
    cmake ..
    make install

## Usage

Although each of the modules may be used on its own, the two important macros / functions used by NitroShare components are `CPL_OPTIONS()` and `CPL_LIBRARY()`. Sample usage is as follows:

    include(NitroShare/CrossPlatformLibrary)

    cpl_options()
    cpl_library(NAME MyLibrary
        VERSION 0.1.0
        SRC someclass.cpp
    )

Each of the source files includes comments documenting usage.
