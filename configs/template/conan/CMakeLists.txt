cmake_minimum_required(VERSION 3.10.0)
project(proj)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

add_executable(proj main.cc)
target_link_libraries(proj ${CONAN_LIBS})