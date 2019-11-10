set(CMAKE_TOOLCHAIN_FILE $ENV{HOME}/work/vcpkg/scripts/buildsystems/vcpkg.cmake)
cmake_minimum_required(VERSION 3.10.0)
project(proj)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "No build type selected, default to Debug")
  set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Build type (default Debug)" FORCE)
endif()

add_executable(proj main.cc)
target_compile_features(proj PUBLIC cxx_std_17)