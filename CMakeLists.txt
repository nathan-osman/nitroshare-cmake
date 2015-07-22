cmake_minimum_required(VERSION 2.8.11)
project(nitroshare-cmake)

# The entire build script consists of copying the files to their destination
install(DIRECTORY NitroShare DESTINATION "${CMAKE_ROOT}/Modules")
