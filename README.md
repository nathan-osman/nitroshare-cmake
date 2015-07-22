## NitroShare CMake Macros

A collection of CMake macros and functions that simplify the creation of the cross-platform executables and libraries that comprise the NitroShare project.

### Installation

The entire collection can be installed by running the following commands:

    mkdir build
    cd build
    cmake ..
    make install

## Usage

To include a file in a CMake project, simply use `include()`:

    include(NitroShare/WindowsResourceFile)
